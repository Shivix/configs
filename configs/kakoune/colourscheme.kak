# Relies on terminal colours

add-highlighter global/ regex \b(\w+)(::)?(<[\w:]+>)?\( 1:function
add-highlighter global/ regex ([-+*&=?%^!|<>,.:\;\\/()\[\]{}]|->|~=) 0:operator
# include paths
add-highlighter global/ regex '#include ([<>"\w./]+)' 1:includepath

# Seems to be another similar one existing, should overwrite it.
add-highlighter global/ regex \b(TODO|FIXME): 1:default+rb

# Highlight trailing whitespace
add-highlighter global/ regex \h+$ 0:default,bright-black

hook global ModeChange (push|pop):insert:.* %{
    set-face global PrimaryCursor      black,bright-white,+f
}
hook global ModeChange (push|pop):.*:insert %{
    set-face global PrimaryCursor      black,yellow,+f
}

hook global BufSetOption filetype=scrollback %{
    # Shell prompt
    add-highlighter buffer/ regex 'shivix@[^$]*\$' 0:bright-yellow
}

# Custom
set-face global search black,bright-yellow,+f

# Code highlighting
set-face global value         bright-magenta
set-face global type          bright-yellow
set-face global variable      default
set-face global module        bright-magenta
set-face global function      bright-cyan
set-face global string        bright-green
set-face global includepath   bright-green,+f
set-face global keyword       bright-red
set-face global operator      yellow
set-face global attribute     bright-red
set-face global comment       white
set-face global documentation comment
set-face global meta          bright-magenta
set-face global builtin       keyword

# Markdown highlighting
set-face global header bright-green+b
set-face global mono   bright-magenta
set-face global link   bright-blue
set-face global bullet yellow

# Info box
set-face global InfoBlock bright-magenta
set-face global InfoDiagnosticError bright-red
set-face global InfoDiagnosticWarning yellow

set-face global PrimarySelection   black,white+fg
set-face global SecondarySelection white,bright-black+fg
set-face global PrimaryCursor      black,bright-white
set-face global SecondaryCursor    black,white
set-face global PrimaryCursorEol   PrimarySelection
set-face global SecondaryCursorEol SecondarySelection
set-face global LineNumbers        white
set-face global LineNumbersWrapped black
set-face global MenuForeground     default,+r
set-face global MenuBackground     default,bright-black
set-face global Information        default
set-face global Error              +u
set-face global DiagnosticError    +u
set-face global DiagnosticWarning  yellow
set-face global StatusLine         default
set-face global StatusLineMode     default
set-face global StatusLineInfo     default
set-face global BufferPadding      bright-black
set-face global Whitespace         bright-black,+f
