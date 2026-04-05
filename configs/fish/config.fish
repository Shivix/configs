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
