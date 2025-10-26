update_tmux_status() {
    tmux refresh-client -S
}
chpwd_functions+=(update_tmux_status)

find_func() {
    rg -A 200 "$@" | awk '{ print $0; } /^}/ { exit 0 }'
}

rund() {
    local file=$(fd -1 --type x --full-path "$1" cmake-build-debug)
    "$file" "${@:2}"
}

cat_between() {
    awk -v start="$1" -v end="$2" '
    $0 ~ start { x = 1 }
    $0 ~ end { x = 0 }
    { if (x == 1) print $0 }'
}

mkcd() {
    mkdir "$@" && cd "$@"
}

config_diff() {
    nvim -d "$HOME/GitHub/configs/$@" "$HOME/.config/$@"
}

config_repo_diff() {
    fd --type file | while IFS= read -r file; do
        local diff=$(diff "$file" "$HOME/.config/$file" 2>/dev/null)
        if [[ -n $diff ]]; then
            echo "$file"
        fi
    done
}

fzk8slogs() {
    kubectl logs "$@" | sed 's/\x01/|/g' | fzf --delimiter : --preview 'echo {} | cut -f2- -d":" | prefix -v' --preview-window up:50%:wrap --multi
}
alias fzl="fzk8slogs"

update_copyright() {
    git diff --name-only --ignore-submodules | while IFS= read -r file; do
        sed -i "0,/2020\|2021\|2022\|2023/ s//2024/g" "$file"
    done
}

wt_status() {
    local worktrees=$(git worktree list | awk '{print $1}')
    local num_wt=$(echo "$worktrees" | wc -l)
    local prev_dir=$(pwd)
    if [[ $num_wt -le 1 ]]; then
        return
    fi
    echo $worktrees | while IFS= read -r worktree; do
        if [[ $worktree == $(echo "$worktrees" | head -n1) ]]; then
            continue
        fi
        echo -e "\033[32m$worktree\033[0m"
        cd "$worktree" || continue
        git status -s --show-stash
        git submodule foreach git branch --show-current | rg -v Entering
        git log | awk 'NR == 5'
    done
    cd "$prev_dir"
}

grebase() {
    local should_stash=$(git status --short --ignore-submodules --untracked=no)
    if [[ -n $should_stash ]]; then
        git stash
    fi
    local master=$(git branch -l master main | cut -c 3-)
    git rebase -i "upstream/$master"
    if [[ -n $should_stash ]]; then
        git stash pop
    fi
}

docker-gdb() {
    local container_id=$(docker container ps -a | rg $@ | awk '{print $1; exit}')
    docker exec -i -t $container_id gdb -p 1
}

src() {
    local source=$(cargo run --bin moxi_source)
    local source=$(string split ":" $source)
    bat $source[1] --highlight-line $source[2]
}
step() {
    cargo run --bin moxi_step -- $@
    src
}

cat_tmp() {
    local tmpfile=$(mktemp)
    nvim $tmpfile
    cat $tmpfile
    rm -f $tmpfile
}
