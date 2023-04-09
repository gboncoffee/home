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
# fzf
export FZF_DEFAULT_COMMAND='rg --glob "!*.git*" --hidden --files'
export FZF_DEFAULT_OPTS="
--no-info
--preview
'highlight -O ansi {} 2> /dev/null || head --bytes=1000000 {}'
--color=dark
--color=fg:-1,bg:-1,hl:#5fff87,fg+:-1,bg+:-1,hl+:#ffaf5f
--color=info:#af87ff,prompt:#5fff87,pointer:#ff87d7,marker:#ff87d7,spinner:#ff87d7
"
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
# julia
export JULIA_DEPOT_PATH="$XDG_DATA_HOME/julia"

# default programs
export EDITOR=kak
export BROWSER=firefox
export TERMINAL=alacritty
export CC=clang

# sensible defaults
export QT_QPA_PLATFORMTHEME=gtk2
export GTK_THEME=Flat-Remix-GTK-Blue-Dark-Solid
export WORDCHARS=""
export PATH="$HOME/.local/bin/:$HOME/opt/bin:$PATH"
. "/home/gb/.local/share/cargo/env"

