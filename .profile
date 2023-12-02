# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
umask 077

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# set PATH so it includes the plan 9 installation if it exists, and set Plan 9
# configuration
if [ -d "$HOME/opt/plan9" ]; then
    PLAN9="$HOME/opt/plan9"
    PATH="$PATH:$HOME/opt/plan9/bin"
    export PLAN9
    export font='/mnt/font/Iosevka-Medium/22a/font'
fi

export EDITOR=nano
PATH="$HOME/opt/bin:$PATH:$HOME/.cargo/bin:$HOME/go/bin"
. "$HOME/.cargo/env"
