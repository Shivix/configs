#!/bin/sh

xmodmap "$HOME/.Xmodmap"
xrdb "$HOME/.Xresources"

feh --no-fehbg --bg-scale "$HOME/Pictures/Wallpapers/sidcyberpunk.png" &
status_bar &
dunst &
exec dwm
