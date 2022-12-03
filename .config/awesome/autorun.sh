#!/bin/sh

run() {
    if ! pgrep -f "$1" ;
    then
        "$@" &
    fi
}

run "mpd"
run "picom"
run "unclutter --start-hidden --jitter 10 --ignore-scrolling"
run "/usr/lib/xfce-polkit/xfce-polkit"
