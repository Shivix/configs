set -l num_cpus (math (nproc) - 1)
abbr make "make -j$num_cpus"
abbr md "make --no-print-directory -j$num_cpus -C cmake-build-debug"
abbr mr "make --no-print-directory -j$num_cpus -C cmake-build-release"

abbr cmd "cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_BUILD_TYPE=Debug -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ .."
abbr cmr "cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ .."

abbr ctd "ctest --test-dir cmake-build-debug"
abbr ctr "ctest --test-dir cmake-build-release"

abbr godebug "go build -gcflags=all='-N -l'"

abbr cr "cargo run"
abbr crr "cargo run --release"

abbr rm "rm -i"
abbr cp "cp -i"
abbr mv "mv -i"

abbr tree "tree --gitignore"

abbr gamend "git commit --amend"
abbr gfetch "git fetch upstream"
abbr gfetchall "git fetch --all --prune -j$num_cpus"
abbr gpush "git push origin"
abbr gs "git status --short"
abbr gblame "git blame -wCCC"
abbr wt "git worktree"
abbr --command=git --position=anywhere -- --fwl "--force-with-lease"
abbr gitlscpp "git ls-files '*.cpp' '*.hpp' '*.cxx' '*.hxx'"
abbr gdiff "git difftool"

abbr kc "kubectl"
abbr --command=kubectl --position=anywhere rr "rollout restart"
abbr --command=kubectl --position=anywhere uc "config use-context"

abbr dexec --set-cursor "docker exec -it % bash"
abbr dbuild --set-cursor "docker build -t % ."
abbr drun "docker run -it"
abbr dc "docker-compose"

abbr ap "ansible-playbook"

abbr refresh "source ~/.config/fish/config.fish"

abbr trim_whitespace "git ls-files | xargs sed -i 's/[[:space:]]*\$//'"

abbr --position=anywhere fix2pipe "sed 's/\x01/|/g'"
abbr --position=anywhere delnewline ':a;N;$!ba;'
abbr --position=anywhere orderlogs "sort -k3,3 -k4,4"
