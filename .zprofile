export PYTHONSTARTUP="$HOME/.config/pyrc.py"
export EDITOR="emacsclient -c -a emacs"
export BROWSER=chromium
export TERMINAL=st

export QT_QPA_PLATFORMTHEME=qt5ct

# this makes Java use GTK, system fonts and antialiasing. and fix issues with WM
export JDK_JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
export _JAVA_AWT_WM_NONREPARENTING=1

export PATH="$PATH:$HOME/.cargo/bin:$HOME/go/bin:$HOME/.local/bin:$HOME/.luarocks/bin:$HOME/opt/bin"

# opam configuration
test -r $HOME/.opam/opam-init/init.sh && . $HOME/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
