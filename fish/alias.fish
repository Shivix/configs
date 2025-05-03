set -l num_cpus (math (nproc) - 1)
abbr make "make -j$num_cpus"
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
abbr kc "kubectl"

abbr gamend "git commit --amend"
abbr gfetch "git fetch upstream"
abbr gfetchall "git fetch --all --prune -j$num_cpus"
abbr gpush "git push origin"
abbr gs "git status"
abbr gblame "git blame -wCCC"

abbr --command=git --position=anywhere -- --fwl "--force-with-lease"

abbr gitlscpp "git ls-files '*.cpp' '*.hpp' '*.cxx' '*.hxx'"

abbr godebug "go build -gcflags=all='-N -l'"

abbr nvrg "nvim -c \"lua require('fzf-lua').live_grep()\""

abbr trim_whitespace "git ls-files | xargs sed -i 's/[[:space:]]*\$//'"

abbr --position=anywhere fix2pipe "sed 's/\x01/|/g'"
abbr --position=anywhere delnewline ':a;N;$!ba;'
abbr --position=anywhere orderlogs "sort -k3,3 -k4,4"
