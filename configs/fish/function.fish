function fzf-complete --description "Provides fuzzy commandline completion"
    set -l cmdline (commandline -c)
    set -l cmd (string split ' ' $cmdline)

    if test $cmd[1] = "sudo" -o $cmd[1] = "env"
        return
    end

    # Trigger cd completion if commandline is empty
    if test "$cmd" = "cd " -o "$cmd" = ""
        set -f preview --preview "ls --color=always {}"
        set -f complist (cat $ZUA_DATA_FILE)
    else if test (commandline -t) = ""
        set -f preview --preview 'bat --color=always {} 2>/dev/null || ls --color=always {}'
        set -f complist (fd .)
    else
        set -f complist (complete -C $cmdline)
    end

    set width (tput cols)
    if test $width -gt 120
        set -f preview_layout --preview-window right:50%:border-left
    else
        set -e preview
    end

    set -l result (string join -- \n $complist | fzf --multi --exit-0 --select-1 --height 30% $preview $preview_layout | cut -f1)
    commandline -tr -- (string join -- " " $result)
    # Need to repaint after if using --height
    commandline -f repaint
end
# Use builtin completion by default, but add bind to trigger fzf based completion
bind \cf -M insert fzf-complete

function fish_mode_prompt; end
function fish_prompt
    set -l last_status $status
    set -l job (jobs | cut -c1)
    if test (count $job) -gt 0
        printf (set_color blue)"["$job"] "
    end
    if test $last_status -ne 0
        printf (set_color red)"["$last_status"] "
    end

    # $3 will exist when HEAD is detached
    set -f branch (git branch 2>/dev/null | awk -F '[ ()]' '/\*/ { if ($3) print "| "$3" "$6; if (!$3) print "| "$2 }')
    printf '%s | %s %s' (set_color yellow)$USER@$hostname (set_color bryellow)(prompt_pwd -d 3 -D 2) (set_color yellow)$branch
    if contains -- --final-rendering $argv
        set -l date_str (set_color bryellow)(date "+%H:%M:%S")
        printf "\r\033[%sC%s" (math (tput cols) - 8) $date_str
    end

    printf \n
    printf (set_color bryellow)'$ '
    set_color normal
end

function fzffix --description "Put the input into fzf and preview with prefix"
    fzf --multi --preview "prefix -v {}" --preview-window 25%:wrap
end

function fzfpac --description "Fuzzy find pacman packages"
    pacman -Slq | fzf --multi --preview 'pacman -Si {1}'
end

function fzflus --description "Fuzzy find lus journals"
    lus "" --short | fzf --multi --preview "lus {} --fixed-strings --file | xargs bat -H 1 --language markdown --color=always"
end

function nvf
    set -g last_nvim_file (fzf --preview 'bat --color=always {}')
    if test -n "$last_nvim_file"
        nvim $last_nvim_file
    else
        return 130
    end
end
function nvo
    nvim $last_nvim_file
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

function mkcd --description "Creates directory and cds into it"
    mkdir $argv && cd $argv
end

function update_copyright --description "Increment the copyright year on any modified files"
    set -l files (git diff --name-only --ignore-submodules)
    if test -z "$files"
        set -l files (git show $argv --pretty="" --name-only --ignore-submodules)
    end
    for file in $files
        sed -i '0,/202[0-9]/ s//2026/g' $file
    end
end

function wt_status --description "Prints the status of each worktree in a repo"
    if not git rev-parse --is-inside-work-tree >/dev/null
        return 1
    end
    set -l worktrees (git worktree list | awk 'NR > 1 {print $1}')
    for worktree in $worktrees
        if test (basename "$worktree") = "pull_request"
            continue
        end
        set_color bryellow; echo $worktree; set_color normal
        git -C $worktree status -s --show-stash
        git -C $worktree submodule foreach git branch --show-current | rg -v Entering
        git -C $worktree log upstream/master..HEAD | awk 'NR == 5'
    end
end

function grebase --description "Rebase branch keeping changes intact"
   if not git rev-parse --is-inside-work-tree >/dev/null
       return 1
   end

    set -l should_stash (git status --short --ignore-submodules --untracked=no --porcelain)
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

function githubpr --description "Generate a GitHub pull request URL"
   if not git rev-parse --is-inside-work-tree >/dev/null
       return 1
   end

   set -l target_branch (git branch -l master main | cut -c 3-)
   if test (count $argv) -gt 0
       set target_branch $argv[1]
   end
   set -l target_repo (git remote get-url upstream | sed -E 's/(git@|https:\/\/)github.com[:\/](.*)\.git/\2/')
   set -l origin (git remote get-url origin | sed -E 's/(git@|https:\/\/)github.com[:\/]([^\/]+)\/.*/\2/')
   set -l current_branch (git branch --show-current)

   echo "https://github.com/$target_repo/compare/$target_branch...$origin:$current_branch"
end

function clipboard
    if isatty stdin
        xsel -ob
    else
        xsel -ib
    end
end

function nvrg
    set -l last_rg (history search --prefix rg --max 1)

    if test -z "$last_rg"
        echo "No 'rg' command found in history."
        return 1
    end

    set -l args (string replace -r '^rg\s+' '' "$last_rg")

    nvim -c "silent grep $args" -c "copen"
end

function ripgrep --description "Run ripgrep in a way closer to standard default grep"
    rg -uuu --no-config
end

function init_fish --description "Sets universal variables for fish shell"
    fish_add_path ~/.cargo/bin
    fish_add_path ~/.go/bin

    set -Ux EDITOR nvim
    set -Ux FZF_DEFAULT_COMMAND "fd --hidden"
    set -Ux FZF_DEFAULT_OPTS "--bind=ctrl-d:preview-half-page-down,ctrl-u:preview-half-page-up"
    set -Ux GOPATH ~/.go
    set -Ux MANPAGER "nvim -c Man!"
    set -Ux RIPGREP_CONFIG_PATH "$HOME/.config/rg/config"
    set -Ux VISUAL nvim

    set -Ux fish_greeting
    set -Ux fish_browser "firefox-developer-edition"
    set -U fish_autosuggestion_enabled 0
    set -U fish_handle_reflow 0
    set -U fish_transient_prompt 1

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
