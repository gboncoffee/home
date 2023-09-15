#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

function start_applets {
    sleep 1
    nm-applet &
    blueman-applet &
    pasystray &
    lxqt-powermanagement &
}

pgrep -f battery-monitor.lua || battery-monitor.lua &
unclutter --ignore-scrolling --start-hidden &
sxhkd &
stalonetray --kludges force_icons_size -i 32 -s 32x40 --grow-gravity SE --geometry 7x1 -bg '#303030' &

start_applets &

exec berry
