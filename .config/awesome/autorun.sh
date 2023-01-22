#!/bin/sh

run() {
    if ! pgrep -f "$1" ;
    then
        $@ &
    fi
}

run "mpd"
run "picom"
run "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
run "unclutter --timeout 3 --jitter 5 --start-hidden"
run "luabatmon"
