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

export PYTHONSTARTUP="$XDG_CONFIG_HOME/pyrc.py"
export EDITOR=nvim
export BROWSER=chromium
export TERMINAL=alacritty

# this makes Java use GTK, system fonts and antialiasing
export JDK_JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'

# sensible defaults
export GTK_THEME=Dracula
export PATH="$PATH:$HOME/.cargo/bin"
