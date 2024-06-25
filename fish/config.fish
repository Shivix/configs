if status is-login
    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
        #exec startx
    end
end

if status --is-interactive
    fzf_key_bindings
    fish_vi_key_bindings
    set fish_cursor_insert line
    for mode in insert default
        bind \cl -M $mode ""
        bind \cd -M $mode ""
        bind \es -M $mode ""
    end
    bind \cr -M default "redo"
    bind U -M visual "togglecase-selection"
    bind _ -M default "beginning-of-line"
    for mode in insert replace
        bind jk -M $mode -m default ""
    end
    zua.lua --init | source
end

alias make "make -j12"
alias md "make --no-print-directory -j12 -C cmake-build-debug"
alias mr "make --no-print-directory -j12 -C cmake-build-release"
alias mdc "make --no-print-directory -j12 -C cmake-build-debug-clang"
alias mrc "make --no-print-directory -j12 -C cmake-build-release-clang"

alias ctd "ctest --test-dir cmake-build-debug"
alias ctr "ctest --test-dir cmake-build-release"
alias ctdc "ctest --test-dir cmake-build-debug-clang"
alias ctrc "ctest --test-dir cmake-build-release-clang"

alias rm "rm -i"
alias mv "mv -i"
alias wt "git worktree"
alias tree "tree --gitignore"
alias rg "rg --smart-case"
alias ssh "env TERM=xterm-256color ssh"
alias tma "tmux attach"

alias godebug "go build -gcflags=all='-N -l'"

alias gitlscpp "git ls-files '*.cpp' '*.hpp' '*.cxx' '*.hxx'"
alias gitformat "gitlscpp | xargs clang-format -i"
alias gittidy "gitlscpp | xargs clang-tidy"

alias gamend "git commit --amend"
alias gfetch "git fetch upstream"
alias gfetchall "git fetch --all --prune --jobs=8"
alias gpush "git push origin"
alias gs "git status"

set -gx scratchfile "$HOME/Documents/Notes/scratch.md"
alias scratch "nvim $scratchfile"

set -gx NVIM_PIPE "$HOME/.cache/nvim/server.pipe"
alias nvimr "nvim --listen $NVIM_PIPE"
alias nvimpipe "nvim --server $NVIM_PIPE --remote"
alias nvimsend "nvim --server $NVIM_PIPE --remote-send"

alias trim_whitespace "git ls-files | xargs sed -i 's/[[:space:]]*\$//'"

set -gx VISUAL nvim
set -gx EDITOR nvim

set -gx GPG_TTY (tty)

set -gx fish_greeting
set -gx fish_browser "firefox-developer-edition"

set -gx FZF_DEFAULT_OPTS "--tiebreak=index --bind=ctrl-d:preview-half-page-down,ctrl-u:preview-half-page-up"
set -gx FZF_DEFAULT_COMMAND "fd --type f --full-path --strip-cwd-prefix"
set -gx RG_PREFIX "rg --column --no-heading --color=always"
set -gx BAT_THEME "gruvbox-dark"
set -gx MANPAGER "nvim -c Man!"

fish_add_path /usr/local/go/bin
fish_add_path ~/go/bin
fish_add_path ~/.local/bin

alias fix2pipe "sed 's/\x01/|/g'"
alias count_includes "gitlscpp | xargs cat | awk -F '[\"<>]' '/#include/ { arr[\$2]++ } END { for (i in arr) print i, arr[i] }' | sort"
alias findrej "awk '\
/35=V/ && match(\$0, /262=([^\x01|]*)/, key) { arr[key[1]] = \$0 }\
/35=Y/ && match(\$0, /262=([^\x01|]*)/, id) {\
    match(arr[id[1]], /55=([^\x01|]*)/, instr);\
    match(arr[id[1]], /([^:]*),/, stream);\
    match(\$0, /58=([^\x01|]*)/, reason);\
    printf(\"%s | %s | %s\n\", stream[1], instr[1], reason[1]);\
}'"

function fzf-complete
    set -l cmd (commandline -co) (commandline -ct)
    if test $cmd[1] = "sudo" -o $cmd[1] = "env"
        return
    end

    if test (commandline -t) = "**"
        set -f complist (fd .)
    else
        set -f complist (complete -C (string join -- ' ' $cmd))
    end

    set -l result (string join -- \n $complist | fzf -m --select-1 | cut -f1)
    commandline -tr -- (string join -- " " $result)
end
bind \ci -M insert fzf-complete

function fish_mode_prompt; end
function fish_prompt
    printf '%s$ ' (set_color yellow) (jobs | awk 'NR==1{ print $1 }')
end

function fix_vwap
    sed "s/\\\u0001/|/g" | prefix | awk -v args=$argv '\
    /MDEntryPx/ { price = $3 }\
    /MDEntrySize/ { size = $3; vwap += price * size; total += size; i++;\
    if (i == args) print vwap / total }'
end

function quickdiff
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

function cat_between
    awk -v start=$argv[1] -v end=$argv[2] '
    $0 ~ start { x = 1 }
    $0 ~ end { x = 0 }
    { if (x == 1) print $0 }'
end

function mkcd --wraps mkdir --description "creates directory and cds into it"
    mkdir $argv && cd $argv
end

function config_diff
    nvim -d ~/GitHub/configs/$argv ~/.config/$argv
end

function config_repo_diff
    set -l files (fd --type file)
    for file in $files
        set -l diff (diff $file ~/.config/$file 2>/dev/null)
        if test -n "$diff"
            echo $file
        end
    end
end

function fzk8slogs --wraps "kubectl logs" --description "Fuzzy search kubectl logs"
    kubectl logs $argv | sed 's/\x01/|/g' | fzf --delimiter : --preview 'echo {} | cut -f2- -d":" | prefix -v' --preview-window up:50%:wrap --multi
end
alias fzl "fzk8slogs"

alias nvf "nvim -c \"lua require('fzf-lua').files()\""
alias nvrg "nvim -c \"lua require('fzf-lua').live_grep()\""

function update_copyright --description "Increment the copyright year on any modified files"
    set -l files (git diff --name-only --ignore-submodules)
    if test -z "$files"
        set -l files (git show $argv --pretty="" --name-only --ignore-submodules)
    end
    for file in $files
        sed -i "0,/2020\|2021\|2022/ s//2023/g" $file
    end
end

function wt_status
    set -l worktrees (git worktree list | awk '{print $1}')
    set -l num_wt (count $worktrees)
    set -l prev_dir (pwd)
    if test $num_wt -le 1
        return
    end
    for worktree in $worktrees
        if test "$worktree" = "$worktrees[1]"
            continue
        end
        set_color green
        echo $worktree
        set_color normal
        builtin cd $worktree
        git status -s --show-stash
        git submodule foreach git branch --show-current | rg -v Entering
        git log | awk 'NR == 5'
    end
    cd $prev_dir
end

function grebase
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

function condense_logs
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

function docker-gdb
    set -l container_id (docker container ps -a | rg $argv | awk '{print $1; exit}')
    docker exec -i -t $container_id gdb -p 1
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
