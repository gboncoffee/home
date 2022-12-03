#!/bin/sh

run() {
    if ! pgrep -f "$1" ;
    then
        "$@" &
    fi
}

run "mpd"
run "picom"
run "/usr/lib/xfce-polkit/xfce-polkit"
