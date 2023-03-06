#!/usr/bin/sh

# links files to the ~

mkdir ~/.config 2> /dev/null
mkdir ~/.local 2> /dev/null
mkdir ~/.local/share 2> /dev/null
ln -sf $PWD/.config/* ~/.config/
ln -sf $PWD/.local/bin ~/.local/bin
ln -sf $PWD/.local/share/* ~/.local/share
ln -sf $PWD/.xprofile ~/.xprofile
ln -sf $PWD/.zshenv ~/.zshenv
ln -sf $PWD/.ghci ~/.ghci
ln -sf $PWD/.icons ~/.icons
