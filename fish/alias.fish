set -l num_cpus(math (grep -c processor /proc/cpuinfo) - 1)
abbr make "make -j"
abbr md "make --no-print-directory -j$num_cpus -C cmake-build-debug"
abbr mr "make --no-print-directory -j$num_cpus -C cmake-build-release"

abbr ctd "ctest --test-dir cmake-build-debug"
abbr ctr "ctest --test-dir cmake-build-release"

abbr rm "rm -i"
abbr mv "mv -i"
abbr wt "git worktree"
abbr tree "tree --gitignore"
abbr rg "rg --smart-case"
abbr tma "tmux attach"
abbr dc "docker-compose"
abbr cat "bat"

abbr godebug "go build -gcflags=all='-N -l'"

abbr gitlscpp "git ls-files '*.cpp' '*.hpp' '*.cxx' '*.hxx'"

abbr gamend "git commit --amend"
abbr gfetch "git fetch upstream"
abbr gfetchall "git fetch --all --prune -j$num_cpus"
abbr gpush "git push origin"
abbr gs "git status"

abbr scratch "nvim $HOME/Documents/Notes/scratch.md"

abbr nvf "nvim -c \"lua require('fzf-lua').files()\""
abbr nvrg "nvim -c \"lua require('fzf-lua').live_grep()\""

abbr trim_whitespace "git ls-files | xargs sed -i 's/[[:space:]]*\$//'"

abbr --position=anywhere fix2pipe "sed 's/\x01/|/g'"
