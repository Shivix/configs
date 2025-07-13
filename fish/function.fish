function fzf-complete --description "Provides fuzzy commandline completion"
    set -l cmdline (commandline -c)
    set -l cmd (string split ' ' $cmdline)

    if test $cmd[1] = "sudo" -o $cmd[1] = "env"
        return
    end

    set -l fzf_args
    # Use standard completion if a file/directory name has started to be typed.
    if test "$cmd" = "nvim "
        set -f complist (fd . --type f)
        set fzf_args --preview "test -f {} && bat --color=always {}"
    else if test "$cmd" = "cd "
        set fzf_args --preview "ls --color=always {}"
        set -f complist (cat $ZUA_DATA_FILE)
    else if test (commandline -t) = "**"
        set -f complist (fd .)
    else
        set -f complist (complete -C $cmdline)
    end

    set width (tput cols)
    if test $width -gt 120
        set preview_layout "right:50%:border-left"
    else
        set preview_layout "up:50%:border-down"
    end

    set -l result (string join -- \n $complist | fzf --multi --exit-0 --select-1 $fzf_args --preview-window $preview_layout | cut -f1)
    commandline -tr -- (string join -- " " $result)
end
bind \ci -M insert fzf-complete

function fish_mode_prompt; end
function fish_prompt
    set -l branch (git branch 2>/dev/null | awk -F '[ ()]'\
        '/*/ { if ($3) print "| "$3" "$6; if (!$3) print "| "$2 }')
    printf '%s | %s %s\n%s%s$ ' (set_color yellow)(whoami)@(hostname) \
        (set_color bryellow)(prompt_pwd -d 3 -D 2) \
        (set_color yellow)$branch \
        (jobs | awk 'NR==1{ print "\n"$1 }')(set_color bryellow)
end

function exit
    read -l -P 'Are you sure you want to exit fish? (y/n) ' confirmation
    if test "$confirmation" = "y"
        builtin exit
    end
end

function fzffix --description "Put the input into fzf and preview with prefix"
    fzf --multi --preview "prefix -v {}" --preview-window 25%:wrap
end

function fzfpac --description "Fuzzy find pacman packages"
    pacman -Slq | fzf --multi --preview 'pacman -Si {1}'
end

function fzflus --description "Fuzzy find lus journals"
    lus "" --short | fzf --multi --preview "lus {} --file | xargs bat -H 1 --language markdown --color=always"
end

function fzfrg --description "Combination of fzf and ripgrep"
    # || true hides the error message if no query is given.
    env FZF_DEFAULT_COMMAND="$RG_PREFIX $argv || true" \
    fzf --ansi --disabled --delimiter : \
        --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
        --query "$argv" \
        --prompt 'rg> ' \
        --bind 'ctrl-f:transform:
            if test "$FZF_PROMPT" = "rg> "
                echo "unbind(change)+change-prompt(fzf> )+enable-search+transform-query:echo \{q} > /tmp/rg-fzf-r; cat /tmp/rg-fzf-f"
            else
                echo "rebind(change)+change-prompt(rg> )+disable-search+transform-query:echo \{q} > /tmp/rg-fzf-f; cat /tmp/rg-fzf-r"
            end
        ' \
        --preview "bat --color=always {1} --highlight-line {2} --line-range (math max {2}-20,0):+50" \
        --preview-window "border-left" \
        --multi
end

function fix_vwap
    sed "s/\\\u0001/|/g" | prefix | awk -v args=$argv '\
    /MDEntryPx/ { price = $3 }\
    /MDEntrySize/ { size = $3; vwap += price * size; total += size; i++;\
    if (i == args) print vwap / total }'
end

function quickdiff --description "Allows easy diffing between two stdout sources"
    if test $argv[1] = "store"
        echo $argv[2..] >"$HOME/.cache/quickdiff_store.txt"
    else
        echo $argv[1..] >"$HOME/.cache/quickdiff_compare.txt"
        delta "$HOME/.cache/quickdiff_store.txt" "$HOME/.cache/quickdiff_compare.txt"
    end
end

function find_func
    rg -A 200 $argv | awk '{ print $0; } /^}/ { exit 0 }'
end

function rund
    set -l file (fd -1 --type x --full-path $argv[1] cmake-build-debug)
    $file $argv[2..]
end

function mkcd --wraps mkdir --description "Creates directory and cds into it"
    mkdir $argv && cd $argv
end

function config_diff --description "Opens a vimdiff between the version controlled and system used config files"
    if test -f ~/.config/$argv
        nvim -d ~/System/configs/$argv ~/.config/$argv
    end
    if test -f ~/$argv
        nvim -d ~/System/configs/$argv ~/$argv
    end
end

function config_repo_diff --description "Prints the config files that do not match their system used counterparts"
    set -l files (fd --hidden --type file)
    for file in $files
        set -l diff (diff $file ~/.config/$file 2>/dev/null)
        if test -n "$diff"
            echo $file
        end
        set -l diff (diff $file ~/$file 2>/dev/null)
        if test -n "$diff"
            echo $file
        end
    end
end

function update_copyright --description "Increment the copyright year on any modified files"
    set -l files (git diff --name-only --ignore-submodules)
    if test -z "$files"
        set -l files (git show $argv --pretty="" --name-only --ignore-submodules)
    end
    for file in $files
        sed -i '0,/2020|2021|2022|2023/ s//2024/g' $file
    end
end

function wt_status --description "Prints the status of each worktree in a repo"
    if not git rev-parse --is-inside-work-tree >/dev/null
        return 1
    end
    set -l worktrees (git worktree list | awk 'NR > 1 {print $1}')
    set -l num_wt (count $worktrees)
    for worktree in $worktrees
        set_color bryellow; echo $worktree; set_color normal
        git -C $worktree status -s --show-stash
        git -C $worktree submodule foreach git branch --show-current | rg -v Entering
        git -C $worktree log upstream/master..HEAD | awk 'NR == 5'
    end
end

function grebase --description "Rebase branch keeping changes intact"
    set -l should_stash (git status --short --ignore-submodules --untracked=no)
    if test -n "$should_stash"
        git stash
    end
    set -l master (git branch -l master main | cut -c 3-)
    git rebase -i upstream/$master
    if test -n "$should_stash"
        git stash pop
    end
end

function checkout_pr
    git fetch upstream pull/$argv/head
    git switch FETCH_HEAD --detach
end

function condense_logs --description "Condenses FIX logs down to a summary"
    awk 'match($0, /[\||](35=[^|]+)[\||]/, capture) {
        if (!(capture[1] in fix_messages)) {
            fix_messages[capture[1]] = 1
        } else {
            fix_messages[capture[1]] += 1
        }
        next
    }
    {
        # strip time stamp
        sub(/[0-9]{2}:[0-9]{2}:[0-9]{2}\.[0-9]{3} */, "", $0)
        if (!($0 in array)) {
            array[$0] = 1
        } else {
            array[$0] += 1
        }
     }
    END {
        for (i in fix_messages) { print i, fix_messages[i] }
        for (i in array) { print i, array[i] }
    }'
end

function docker-gdb --wraps "docker exec"
    docker exec -it $argv gdb -p 1
end
function docker-gdbserver --wraps "docker exec"
    docker exec -it $argv[1] gdbserver --attach localhost:$argv[2] 1
end

function step
    cargo run --bin moxi_step -- $argv
    src
end
function src
    set -l source (cargo run --bin moxi_source)
    set -l source (string split ":" $source)
    bat $source[1] --highlight-line $source[2]
end

function cat_tmp
    set -l tmpfile (mktemp)
    nvim $tmpfile
    cat $tmpfile
    rm -f $tmpfile
end

function count_includes
    gitlscpp |
    xargs cat |
    awk -F '[\"<>]' '
        /#include/ { arr[\$2]++ }
        END { for (i in arr) print i, arr[i] }' |
    sort
end

function connect_bluetooth
    if not systemctl is-active bluetooth.service
        sudo systemctl start bluetooth.service
    end
    sleep .5
    bluetoothctl connect (bluetoothctl devices | awk '/WF-1000XM5/ { print $2 }')
end
function disconnect_bluetooth
    bluetoothctl disconnect (bluetoothctl devices | awk '/WF-1000XM5/ { print $2 }')
    sudo systemctl stop bluetooth.service
end

function findrej
    awk '/35=V/ && match(\$0, /262=([^\x01|]*)/, key) {
        arr[key[1]] = \$0
    }
    /35=Y/ && match(\$0, /262=([^\x01|]*)/, id) {
        match(arr[id[1]], /55=([^\x01|]*)/, instr);
        match(arr[id[1]], /([^:]*),/, stream);
        match(\$0, /58=([^\x01|]*)/, reason);
        printf(\"%s | %s | %s\n\", stream[1], instr[1], reason[1]);
    }'
end

function darken
    echo "3000" | sudo tee /sys/class/backlight/intel_backlight/brightness >/dev/null
    redshift -P -O 4000
end
function brighten
    echo "13000" | sudo tee /sys/class/backlight/intel_backlight/brightness >/dev/null
    redshift -x
end

function init_fish --description "Sets universal variables for fish shell"
    fish_vi_key_bindings

    fish_add_path ~/.cargo/bin
    fish_add_path ~/.go/bin

    set -Ux FZF_DEFAULT_COMMAND "fd --type f --full-path --strip-cwd-prefix"
    set -Ux FZF_DEFAULT_OPTS "--bind=ctrl-d:preview-half-page-down,ctrl-u:preview-half-page-up"
    set -Ux GOPATH ~/.go
    set -Ux MANPAGER "nvim -c Man!"
    set -Ux RG_PREFIX "rg --column --no-heading --color=always"
    set -Ux VISUAL nvim

    set -Ux fish_greeting
    set -Ux fish_browser "firefox-developer-edition"
    set -U fish_autosuggestion_enabled 0

    set -U fish_color_autosuggestion grey
    set -U fish_color_cancel brwhite
    set -U fish_color_command brcyan
    set -U fish_color_comment grey
    set -U fish_color_end brorange
    set -U fish_color_error --underline
    set -U fish_color_escape brorange
    set -U fish_color_keyword brred
    set -U fish_color_normal brwhite
    set -U fish_color_operator brorange
    set -U fish_color_param brwhite
    set -U fish_color_quote brgreen
    set -U fish_color_redirection brmagenta
    set -U fish_color_selection --background=grey black
end
