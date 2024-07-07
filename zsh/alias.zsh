alias make="make -j12"
alias md="make --no-print-directory -j12 -C cmake-build-debug"
alias mr="make --no-print-directory -j12 -C cmake-build-release"
alias mdc="make --no-print-directory -j12 -C cmake-build-debug-clang"
alias mrc="make --no-print-directory -j12 -C cmake-build-release-clang"

alias ctd="ctest --test-dir cmake-build-debug"
alias ctr="ctest --test-dir cmake-build-release"
alias ctdc="ctest --test-dir cmake-build-debug-clang"
alias ctrc="ctest --test-dir cmake-build-release-clang"

alias rm="rm -i"
alias mv="mv -i"
alias ls="ls --color=auto"
alias wt="git worktree"
alias tree="tree --gitignore"
alias rg="rg --smart-case"
alias ssh="env TERM=xterm-256color ssh"
alias tma="tmux attach"

alias godebug="go build -gcflags=all='-N -l'"

alias gitlscpp="git ls-files '*.cpp' '*.hpp' '*.cxx' '*.hxx'"
alias gitformat="gitlscpp | xargs clang-format -i"
alias gittidy="gitlscpp | xargs clang-tidy"

alias gamend="git commit --amend"
alias gfetch="git fetch upstream"
alias gfetchall="git fetch --all --prune --jobs=8"
alias gs="git status"

alias scratch="nvim $HOME/Documents/Notes/scratch.md"

alias trim_whitespace="git ls-files | xargs sed -i 's/[[:space:]]*\$//'"

alias fix2pipe="sed 's/\x01/|/g'"
alias count_includes="gitlscpp | xargs cat | awk -F '[\"<>]' '/#include/ { arr[\$2]++ } END { for (i in arr) print i, arr[i] }' | sort"
alias findrej="awk '\
/35=V/ && match(\$0, /262=([^\x01|]*)/, key) { arr[key[1]] = \$0 }\
/35=Y/ && match(\$0, /262=([^\x01|]*)/, id) {\
    match(arr[id[1]], /55=([^\x01|]*)/, instr);\
    match(arr[id[1]], /([^:]*),/, stream);\
    match(\$0, /58=([^\x01|]*)/, reason);\
    printf(\"%s | %s | %s\n\", stream[1], instr[1], reason[1]);\
}'"

alias nvf="nvim -c 'lua require(\"fzf-lua\").files()'"
alias nvrg="nvim -c 'lua require(\"fzf-lua\").live_grep()'"

