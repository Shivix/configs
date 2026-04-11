function fp-complete --description "Provides fuzzy commandline completion"
    set -l cmdline (commandline -c)
    set -l cmd (string split ' ' $cmdline)

    if test $cmd[1] = "sudo" -o $cmd[1] = "env"
        return
    end

    # Trigger cd completion if commandline is empty
    if test "$cmd" = "cd " -o "$cmd" = ""
        set -f complist (cat $ZUA_DATA_FILE)
    else if test (commandline -t) = "**"
        set -f complist (fd --hidden --exclude .git)
    else
        set -f complist (complete -C $cmdline)
    end

    set -l len (count $complist)
    if test $len -eq 0
        return
    else if test $len -eq 1
        set -f result (echo $complist | cut -f1)
    else
        # Cut out the description. Do it inline to avoid flattening result.
        set -f result (string join -- \n $complist | fp | cut -f1)
    end
    commandline -tr -- (string join -- " " $result)
    commandline -f repaint
end
# Use builtin completion by default, but add bind to trigger fp based completion
bind \cf -M insert fp-complete

function fp-history --description "Search shell history using fp"
    set -l cmdline (commandline -c)

    if test -z "$cmdline"
        # Null delimiters since some history values will contain multiple lines.
        set -f result (history search --null | fp --read-null)
    else
        set -f result (history search --null --prefix "$cmdline" | fp --read-null)
    end

    commandline -r -- (string join \n $result)
    commandline -f repaint
end
bind \cr -M insert fp-history

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
    # End selection if leftover from kakoune movement.
    commandline -f end-selection
end

function kek
    set -l session_name "main_kak_session"
    if not kak -l | grep -Fxq "$session_name"
        setsid kak -d -s "$session_name" &
        sleep 0.1
    end
    if test -z "$argv"
        kak -c "$session_name" -e "edit -scratch *scratch*"
    else
        kak -c "$session_name" $argv
    end
end

function kf
    if test -z "$argv"
        return
    end
    kek -e "fp $argv"
end

function krg
    if test -z "$argv"
        return
    end
    kek -e "grep $argv"
end

function krglast
    set -l last_rg (history search --prefix rg --max 1)

    if test -z "$last_rg"
        echo "No 'rg' command found in history."
        return 1
    end

    set -l args (string replace -r '^rg\s+' '' "$last_rg")
    kek -e "grep $args"
end

function kcmd
    if test (count $argv) -eq 0
        echo "usage: run_or_kak <command...>"
        return 2
    end

    set -l tmp_name "/tmp/kak_cmd_buffer"

    $argv | kek -e "rename-buffer -file $tmp_name"
    if test -e "$tmp_name"
        cat "$tmp_name"
        rm "$tmp_name"
    end
end

function fix_vwap
    sed "s/\\\u0001/|/g" | prefix | awk -v args=$argv '\
    /MDEntryPx/ { price = $3 }\
    /MDEntrySize/ { size = $3; vwap += price * size; total += size; i++;\
    if (i == args) print vwap / total }'
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
    bluetoothctl connect (bluetoothctl devices | awk '/WF-1000XM5/ { print $2 }')
end
function disconnect_bluetooth
    bluetoothctl disconnect (bluetoothctl devices | awk '/WF-1000XM5/ { print $2 }')
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

   xdg-open "https://github.com/$target_repo/compare/$target_branch...$origin:$current_branch"
end

function clipboard
    if isatty stdin
        xsel -ob
    else
        xsel -ib
    end
end

function ripgrep --description "Run ripgrep in a way closer to standard default grep"
    rg -uuu --no-config
end

function colourhex
    set hex (string replace "#" "" $argv)

    set r (math "0x"(string sub -s 1 -l 2 $hex))
    set g (math "0x"(string sub -s 3 -l 2 $hex))
    set b (math "0x"(string sub -s 5 -l 2 $hex))

    printf "\e[48;2;%d;%d;%dm        \e[0m\n" $r $g $b
end

function lua_std
    set -l url "https://www.lua.org/ftp/refman-5.5.tar.gz"
    set -l dest "$HOME/Documents/LuaDocs"
    set -l tar_dest "$HOME/Downloads/refman-5.5.tar.gz"

    if not test -d "$dest"
        curl -fL $url -o "$tar_dest"
        mkdir -p "$dest"
        tar xvf "$tar_dest" --strip-components=2 -C "$dest"
        rm "$tar_dest"
    end

    firefox "$dest/contents.html"
end

function kman
    kek -e "man $argv"
end

function paste_editor
    set -l tmpfile (mktemp /tmp/paste_editor_XXXXXX.sh)
    kek -e "e -scratch scrollback; set buffer filetype scrollback; execute-keys '%d!xsel -ob<ret>;'"
end
