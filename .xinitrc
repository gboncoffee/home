#!/bin/sh

# fix portals
systemctl --user import-environment DISPLAY XAUTHORITY
if command -v dbus-update-activation-environment >/dev/null 2>&1; then
    dbus-update-activation-environment DISPLAY XAUTHORITY
fi

# status bar
BAT=/sys/class/power_supply/BAT1
while true; do
    xsetroot -name "BAT $(cat $BAT/capacity) $(date +'%a %b %d, %H:%M')"
    sleep 1
done &

xsetroot -gray
xsettingsd &
[ -f ~/.xprofile ] && . ~/.xprofile
setxkbmap -layout us -variant altgr-intl

export GTK_USE_PORTAL=1

exec dwm
