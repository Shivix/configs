HISTFILE=~/.histfile
HISTSIZE=2000
SAVEHIST=10000
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_SAVE_NO_DUPS
setopt globdots

bindkey -v
bindkey -M viins 'jk' vi-cmd-mode
bindkey -r '^L'
bindkey -r '^D'
bindkey -r '^I'
bindkey -r '\eL'
bindkey -M vicmd '_' beginning-of-line
bindkey -M viins "^?" backward-delete-char

zle-keymap-select() {
  case $KEYMAP in
    vicmd) echo -ne '\e[1 q';;
    viins|main) echo -ne '\e[5 q';;
  esac
}
zle -N zle-keymap-select
set_beam() {
    echo -ne '\e[5 q'
}
precmd_functions+=(set_beam)

autoload -U compinit && compinit
source <(fzf --zsh)
#source ~/.config/zsh/fzf-tab/fzf-tab.plugin.zsh

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source <(zua.lua init zsh)

PS1="%F{yellow}%(1j.%j.)$ "

export VISUAL=nvim
export EDITOR=nvim

export GPG_TTY=$(tty)

export FZF_DEFAULT_OPTS="--tiebreak=index --bind=ctrl-d:preview-half-page-down,ctrl-u:preview-half-page-up"
export FZF_DEFAULT_COMMAND="fd --type f --full-path --strip-cwd-prefix"
export RG_PREFIX="rg --column --no-heading --color=always"
export BAT_THEME="gruvbox-dark"
export MANPAGER="nvim -c Man!"
