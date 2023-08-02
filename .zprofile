export PYTHONSTARTUP="$HOME/.config/pyrc.py"
export EDITOR=vim
export BROWSER=chromium
export TERMINAL=alacritty

export QT_QPA_PLATFORMTHEME=qt5ct

# this makes Java use GTK, system fonts and antialiasing
export JDK_JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'

export PATH="$PATH:$HOME/.cargo/bin:$HOME/go/bin:$HOME/.local/bin"

# opam configuration
test -r $HOME/.opam/opam-init/init.sh && . $HOME/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
