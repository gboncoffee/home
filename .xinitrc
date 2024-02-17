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

export _JAVA_AWT_WM_NONREPARENTING=1
trayer --edge top --align left --widthtype request --height 64 --alpha 0 &
xclock -digital -strftime '%Y-%m-%d %H:%M' -face 'Liberation Sans:size=22' -geometry +300+0 &
nm-applet &
pnmixer &
xfce4-power-manager &
xsettingsd &
#nitrogen --restore
xsetroot -solid '#757373'
setxkbmap -option keypad:pointerkeys -layout us -variant altgr-intl
slstatus &
redshift -l $(curl -s "https://location.services.mozilla.com/v1/geolocate?key=geoclue" | awk 'OFS=":" {print $3,$5}' | tr -d ',}') &
iguassu &
exec alacritty --config-file ~/.config/alacritty/alacritty-login.toml
