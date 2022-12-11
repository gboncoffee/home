#!/bin/sh

run() {
    if ! pgrep -f "$1" ;
    then
        $@ &
    fi
}

run "mpd"
run "picom"
run "/usr/lib/xfce-polkit/xfce-polkit"
run "unclutter --timeout 3 --jitter 5 --start-hidden"
