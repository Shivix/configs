fish_vi_key_bindings

for mode in insert default
    bind \cl -M $mode ""
    bind \cd -M $mode ""
    bind \es -M $mode ""
end

for mode in insert replace
    bind jk -M $mode -m default ""
end

function __kak_do_if_on_whitespace
    commandline -f begin-selection
    set -l ch (commandline --current-selection)
    if string match -qr '\s' -- $ch
        commandline -f $argv
    end
end

function __kak_b_prestep
    commandline -f begin-selection backward-char
    set -l sel (commandline --current-selection)
    commandline -f forward-char
    if string match -qr '\s' -- $sel
        commandline -f backward-char
    end
end

bind -M default h end-selection backward-char
bind -M default H begin-selection backward-char
bind -M default l end-selection forward-char
bind -M default L begin-selection forward-char

bind -M default alt-h end-selection begin-selection beginning-of-line
bind -M default gh end-selection beginning-of-line

bind -M default alt-l end-selection begin-selection end-of-line
bind -M default gl end-selection end-of-line

bind -M default gg end-selection beginning-of-buffer
bind -M default ge end-selection end-of-buffer

bind -M default w "__kak_do_if_on_whitespace forward-char" end-selection begin-selection forward-word
bind -M default W begin-selection forward-word

bind -M default b __kak_b_prestep end-selection begin-selection backward-word
bind -M default B begin-selection backward-word

bind -M default e "__kak_do_if_on_whitespace forward-char" end-selection begin-selection forward-word-end
bind -M default E begin-selection forward-bigword-end

bind -M default f end-selection begin-selection forward-jump
bind -M default F begin-selection forward-jump

bind -M default t end-selection begin-selection forward-jump-till
bind -M default T begin-selection forward-jump-till

bind -M default x beginning-of-line begin-selection end-of-line
bind -M default % beginning-of-buffer begin-selection end-of-buffer

bind -M default \; end-selection
bind -M default \e\; swap-selection-start-stop

bind -M default d begin-selection kill-selection end-selection
bind -M default c begin-selection kill-selection end-selection -m insert

bind -M default i end-selection -m insert
bind -M default a end-selection forward-char -m insert
bind -M default A end-selection end-of-line -m insert

bind -M default \e. repeat-jump

bind u -M default end-selection undo
bind U -M default end-selection redo

#bind ~ -M default togglecase-selection
bind ` -M default togglecase-selection
