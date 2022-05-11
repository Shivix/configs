starship init fish | source
zoxide init --cmd=cd fish | source

alias make="make -j12"
alias rg="rg --smart-case --line-number"
alias rm="rm -i"
alias mv="mv -i"

fzf_key_bindings
alias fzh="fzf-history-widget"

set -gx NVIM_PIPE "$HOME/.cache/nvim/server.pipe"
alias nvimr="nvim --listen $NVIM_PIPE"
alias nvimfzf="nvim (fzf --multi)"
alias nvimscratch="nvim ~/Documents/Notes/scratch.md"
alias nvimpipe="nvim --server $NVIM_PIPE --remote"
alias nvimsend="nvim --server $NVIM_PIPE --remote-send"

set -gx VISUAL nvim
set -gx EDITOR nvim

set -gx GPG_TTY (tty)

set -gx fish_greeting "Welcome to fish, the friendly interactive shell"
set -gx fish_browser "firefox-developer-edition"

set -gx FZF_DEFAULT_OPTS "--tiebreak=index --bind=ctrl-d:page-down,ctrl-u:page-up"
set -gx FZF_DEFAULT_COMMAND "fd --type f"

set -gx RG_PREFIX "rg --column --no-heading --color=always"

set -gx BAT_THEME "gruvbox-dark"

set -gx PYTHONPATH ~/cpp/python
fish_add_path /usr/local/go/bin
fish_add_path ~/go/bin
fish_add_path ~/.local/bin

function man --wraps man
    set -x LESS_TERMCAP_md (set_color --bold yellow)
    set -x LESS_TERMCAP_me (set_color normal)
    set -x LESS_TERMCAP_so (set_color --reverse cyan)
    set -x LESS_TERMCAP_se (set_color normal)
    set -x LESS_TERMCAP_us (set_color --underline bryellow)
    set -x LESS_TERMCAP_ue (set_color normal)
    command man $argv
end

function mkcd --wraps mkdir --description "creates directory and cds into it"
    mkdir $argv && cd $argv
end

alias fix2pipe="sed -e 's/\x01/|/g'"

function config_diff
    nvim -d ~/GitHub/configs/$argv ~/.config/$argv
end

function fzk8slogs --wraps "kubectl logs" --description "Fuzzy search kubectl logs"
    kubectl logs $argv | sed -e 's/\x01/|/g' | fzf --delimiter : --preview 'echo {} | cut -f2- -d":" | prefix -v' --preview-window up:50%:wrap --multi
end
alias fzl="fzk8slogs"

function fznvim --description "Fuzzy find files and open them in nvim"
    set files (fzf --multi)
    for i in $files
        set file (fd --absolute-path --type f --full-path $i)
        nvim --server $NVIM_PIPE --remote-silent $file
    end
end
alias fzn="fznvim"

function fzgrep --description "Grep string and open selection in nvim"
    set old_FZF_DEFAULT_COMMAND $FZF_DEFAULT_COMMAND
    set FZF_DEFAULT_COMMAND $RG_PREFIX
    set match (fzf --disabled --ansi \
        --bind "change:reload:$RG_PREFIX {q} || true" \
        --delimiter : \
        --preview "bat --color=always {1} --highlight-line {2}" \
        --preview-window "up,60%,border-bottom,+{2}+3/3,~3" \
        | awk -F ":" '{print $1"\n"$2}')
    set FZF_DEFAULT_COMMAND $old_FZF_DEFAULT_COMMAND
    if test -z "$match"
        return
    end
    set file (fd --absolute-path --type f --full-path $match[1])
    nvim --server $NVIM_PIPE --remote-silent $file
    nvim --server $NVIM_PIPE --remote-send ":$match[2]<CR>"
end
alias fzg="fzgrep"

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.fish.inc" ]; . "$HOME/google-cloud-sdk/path.fish.inc"; end