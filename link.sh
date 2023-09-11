#!/usr/bin/sh

# links files to the ~

mkdir -p ~/.config 2> /dev/null
mkdir -p ~/.local 2> /dev/null
ln -sf $PWD/.config/* ~/.config/
ln -sf $PWD/.local/bin ~/.local/bin
ln -sf $PWD/.xprofile ~/.xprofile
ln -sf $PWD/.xinitrc ~/.xinitrc
ln -sf $PWD/.bashrc ~/.bashrc
ln -sf $PWD/.profile ~/.profile
ln -sf $PWD/.zprofile ~/.zprofile
ln -sf $PWD/.zshrc ~/.zshrc
ln -sf $PWD/.ghci ~/.ghci
ln -sf $PWD/.vim ~/.vim
