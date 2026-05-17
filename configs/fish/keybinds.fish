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

# Allows treating no selection as a one character selection
function __kak_begin_selection_if_not_already
    set -l sel (commandline --current-selection)
    if test -z "$sel"
        commandline -f begin-selection
    end
end

bind -M default h end-selection backward-char
bind -M default H __kak_begin_selection_if_not_already backward-char
bind -M default l end-selection forward-char
bind -M default L __kak_begin_selection_if_not_already forward-char

bind -M default alt-h begin-selection beginning-of-line
bind -M default gh end-selection beginning-of-line

bind -M default alt-l begin-selection end-of-line
bind -M default gl end-selection end-of-line

bind -M default gg end-selection beginning-of-buffer
bind -M default ge end-selection end-of-buffer

bind -M default w "__kak_do_if_on_whitespace forward-char" begin-selection forward-word
bind -M default W __kak_begin_selection_if_not_already forward-word

bind -M default b __kak_b_prestep begin-selection backward-word
bind -M default B __kak_begin_selection_if_not_already backward-word

bind -M default e "__kak_do_if_on_whitespace forward-char" begin-selection forward-word-end
bind -M default E __kak_begin_selection_if_not_already begin-selection forward-bigword-end

bind -M default f begin-selection forward-jump
bind -M default F __kak_begin_selection_if_not_already forward-jump
bind -M default alt-f begin-selection backward-jump
bind -M default alt-F __kak_begin_selection_if_not_already backward-jump

bind -M default t begin-selection forward-jump-till
bind -M default T __kak_begin_selection_if_not_already forward-jump-till
bind -M default alt-t begin-selection backward-jump-till
bind -M default alt-T __kak_begin_selection_if_not_already backward-jump-till

bind -M default x beginning-of-line begin-selection end-of-line
bind -M default % beginning-of-buffer begin-selection end-of-buffer

bind -M default \; end-selection
bind -M default alt-\; swap-selection-start-stop

bind -M default d __kak_begin_selection_if_not_already kill-selection end-selection
bind -M default c __kak_begin_selection_if_not_already kill-selection end-selection -m insert

bind -M default i end-selection -m insert
bind -M default a end-selection forward-char -m insert
bind -M default A end-selection end-of-line -m insert

bind -M default alt-. begin-selection repeat-jump

bind u -M default end-selection undo
bind U -M default end-selection redo

bind ` -M default __kak_begin_selection_if_not_already downcase-selection
bind \~ -M default __kak_begin_selection_if_not_already upcase-selection

bind -M default alt-j end-of-line kill-line

# TODO: repeat-jump-reverse won't work for opposite brackets.
bind -M default alt-i backward-jump-till begin-selection repeat-jump-reverse
bind -M default alt-a backward-jump begin-selection repeat-jump-reverse

bind -M default m jump-to-matching-bracket begin-selection jump-to-matching-bracket
