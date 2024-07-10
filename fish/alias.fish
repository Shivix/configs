abbr make "make -j12"
abbr md "make --no-print-directory -j12 -C cmake-build-debug"
abbr mr "make --no-print-directory -j12 -C cmake-build-release"
abbr mdc "make --no-print-directory -j12 -C cmake-build-debug-clang"
abbr mrc "make --no-print-directory -j12 -C cmake-build-release-clang"

abbr ctd "ctest --test-dir cmake-build-debug"
abbr ctr "ctest --test-dir cmake-build-release"
abbr ctdc "ctest --test-dir cmake-build-debug-clang"
abbr ctrc "ctest --test-dir cmake-build-release-clang"

abbr rm "rm -i"
abbr mv "mv -i"
abbr wt "git worktree"
abbr tree "tree --gitignore"
abbr rg "rg --smart-case"
abbr ssh "env TERM=xterm-256color ssh"
abbr tma "tmux attach"
abbr dc "docker-compose"

abbr godebug "go build -gcflags=all='-N -l'"

abbr gitlscpp "git ls-files '*.cpp' '*.hpp' '*.cxx' '*.hxx'"
abbr gitformat "gitlscpp | xargs clang-format -i"
abbr gittidy "gitlscpp | xargs clang-tidy"

abbr gamend "git commit --amend"
abbr gfetch "git fetch upstream"
abbr gfetchall "git fetch --all --prune --jobs=8"
abbr gpush "git push origin"
abbr gs "git status"

abbr scratch "nvim $HOME/Documents/Notes/scratch.md"

abbr nvf "nvim -c \"lua require('fzf-lua').files()\""
abbr nvrg "nvim -c \"lua require('fzf-lua').live_grep()\""

abbr --position=anywhere fzffix "fzf --delimiter : --preview 'prefix -v \'{}\'' --preview-window up:50%:wrap --multi"

abbr trim_whitespace "git ls-files | xargs sed -i 's/[[:space:]]*\$//'"

abbr --position=anywhere fix2pipe "sed 's/\x01/|/g'"
