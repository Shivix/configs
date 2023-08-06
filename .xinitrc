#!/bin/sh

xmodmap "$HOME/.Xmodmap"
xrdb "$HOME/.Xresources"

session=${1:-awesome}
case $session in
    xfce|xfce4) exec startxfce4;;
    *)          exec awesome;;
esac
