if status is-login
    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
        #exec startx
    end
end

if status --is-interactive
    fzf_key_bindings
    if test "$fish_key_bindings" = "fish_vi_key_bindings"
        set fish_cursor_insert line
        for mode in insert default
            bind \cl -M $mode ""
            bind \cd -M $mode ""
            bind \es -M $mode ""
        end
        bind \cr -M default "redo"
        bind U -M visual "togglecase-selection"
        bind _ -M default "beginning-of-line"
        bind b -M default backward-bigword
        bind w -M default forward-bigword forward-single-char
        bind e -M default forward-single-char forward-bigword backward-char
        for mode in insert replace
            bind jk -M $mode -m default ""
        end
    end
    zua.lua init fish | source
    source ~/.config/fish/alias.fish
    source ~/.config/fish/function.fish
    # Override /etc/environment
    set -gx EDITOR nvim
    set -gx GPG_TTY (tty)
end
