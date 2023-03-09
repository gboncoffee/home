#!/usr/bin/sh
#
# moving configs away from ~
#
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc-2.0"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/password-store"
# shell and utils
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export HISTFILE="$XDG_DATA_HOME/zsh/histfile"
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
export IPYTHONDIR="$XDG_CONFIG_HOME/ipython"
# julia
export JULIA_DEPOT_PATH="$XDG_DATA_HOME/julia"

# less
export LESS_TERMCAP_mb=$'\e[1;34m'
export LESS_TERMCAP_md=$'\e[1;34m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;36m'

# default programs
export EDITOR=vim
export BROWSER=chromium
export TERMINAL=alacritty
export CC=clang

# sensible defaults
export QT_QPA_PLATFORMTHEME=gtk2
export GTK_THEME=Dracula
export WORDCHARS=""
export PATH="$HOME/.local/bin/:$HOME/opt/bin:$PATH"
. "/home/gb/.local/share/cargo/env"
