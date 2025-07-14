if status is-login
    set -Ue MOTD_WAS_SHOWN
end

if status --is-interactive
    fzf_key_bindings
    if test "$fish_key_bindings" = "fish_vi_key_bindings"
        for mode in insert default
            bind \cl -M $mode ""
            bind \cd -M $mode ""
            bind \es -M $mode ""
        end
        bind \cr -M default "redo"
        bind U -M visual "togglecase-selection"
        bind _ -M default "beginning-of-line"
        for mode in insert replace
            bind jk -M $mode -m default ""
        end
    end
    zua init | source
    source ~/.config/fish/alias.fish
    source ~/.config/fish/function.fish

    set -gx GPG_TTY (tty)

    if status is-login
        return
    end
    # Only show if it hasn't already been shown this session
    if not set -q MOTD_WAS_SHOWN
        fastfetch
        set -U MOTD_WAS_SHOWN yes
    end
end
