# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
umask 077

if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

#
# moving configs away from ~
#
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc-2.0"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/password-store"
# shell and utils
export HISTFILE="$XDG_DATA_HOME/bash/histfile"
export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"
export LESSHISTFILE="-"
# tex
export TEXMFHOME="$XDG_DATA_HOME/tex/texmf"
export TEXMFVAR="$XDG_DATA_HOME/tex/textmf-var"
export TEXMFCONFIG="$XDG_CONFIG_HOME/tex/textmf-config"
# js
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"
# rust
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
# python
export PYTHONSTARTUP="$XDG_CONFIG_HOME/pyrc.py"
# go
export GOPATH="$XDG_DATA_HOME/go"

# default programs
export EDITOR=nvim
export BROWSER=chromium
export TERMINAL=alacritty

# fuck this language. Sun Microsystems and Oracle I FUCKING HATE YOU FOR
# CREATING THE POST-MODERN CYBERPUNK REALITY. I FUCKING HATE YOU ALL!!!!!!!
#
# sorry Bill Joy, you're actually a cool guy ;)
export _JAVA_AWT_WM_NONREPARENTING=1
# this makes Java use GTK, system fonts and antialiasing
export JDK_JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'

# sensible defaults
export GTK_USE_PORTAL=1
export GTK_THEME=Dracula
export QT_QPA_PLATFORMTHEME=qt5ct
export QT_STYLE_OVERRIDE=kvantum
export PATH="$HOME/.local/bin/:$HOME/opt/bin:$PATH:$HOME/.local/share/cargo/bin"
