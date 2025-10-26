local black="#121212"
local red="#cc241d"
local white="#a89984"
local yellow="#d79921"
local brblack="#928374"
local brred="#fb4934"
local brgreen="#b8bb26"
local bryellow="#fabd2f"
local brblue="#83a598"
local brmagenta="#d3869b"
local brcyan="#8ec07c"
local brwhite="#efe2c1"

ZSH_HIGHLIGHT_STYLES[command]=fg=$brcyan
ZSH_HIGHLIGHT_STYLES[function]=fg=$brcyan
ZSH_HIGHLIGHT_STYLES[alias]=fg=$brcyan
ZSH_HIGHLIGHT_STYLES[builtin]=fg=$brcyan
ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=$brred
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=$brgreen
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=$brgreen
ZSH_HIGHLIGHT_STYLES[path]=fg=$brwhite
ZSH_HIGHLIGHT_STYLES[path_prefix]=fg=$brwhite,underline
ZSH_HIGHLIGHT_STYLES[globbing]=fg=$brmagenta
ZSH_HIGHLIGHT_STYLES[brackets]=fg=$yellow
ZSH_HIGHLIGHT_STYLES[operator]=fg=$yellow
ZSH_HIGHLIGHT_STYLES[command-substitution]=fg=$yellow
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]=fg=$yellow
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-unquoted]=fg=$yellow
ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=$yellow
ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=$brcyan,underline
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=$brmagenta
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=$yellow
