if status is-login
    clear
    operator_fetch
end

if status --is-interactive
    source ~/.config/fish/keybinds.fish
    source ~/.config/fish/alias.fish
    source ~/.config/fish/function.fish

    if type -q zua
        zua init | source
    end

    set -gx GPG_TTY (tty)
end

fish_add_path ~/.local/bin
fish_add_path ~/.go/bin

set -gx EDITOR kak
set -gx VISUAL kak
set -gx GOPATH ~/.go
set -gx RIPGREP_CONFIG_PATH "$HOME/.config/rg/config"
set -gx XAUTHORITY "$HOME/.config/X11/xauthority"
set -gx INPUTRC "$HOME/.config/readline/inputrc"
set -gx HISTFILE ""

set -gx fish_greeting
set -gx fish_browser firefox
set -g fish_autosuggestion_enabled 0
set -g fish_handle_reflow 0
set -g fish_transient_prompt 1

set -g fish_color_autosuggestion grey
set -g fish_color_cancel brwhite
set -g fish_color_command brcyan
set -g fish_color_comment grey
set -g fish_color_end brorange
set -g fish_color_error --underline
set -g fish_color_escape brorange
set -g fish_color_keyword brred
set -g fish_color_normal brwhite
set -g fish_color_operator yellow
set -g fish_color_param brwhite
set -g fish_color_quote brgreen
set -g fish_color_redirection brmagenta
set -g fish_color_selection --background=grey black
