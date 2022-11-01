#!/usr/bin/sh

# author Gabriel G. de Brito gabrielgbrito@icloud.com
# version 1.0.0
# since Sep 10, 2022

COMMAND="cp -r"
if [ "$1" == "link" ]
then
    COMMAND="ln -sf"
fi
PREFIX=$("pwd")

mkdir -p $HOME/.config/ $HOME/.local/{share,bin} $HOME/.icons/

find .config/     -maxdepth 1 -exec $COMMAND $PREFIX/{} $HOME/{} \;
find .local/bin   -maxdepth 1 -exec $COMMAND $PREFIX/{} $HOME/{} \;
find .local/share -maxdepth 1 -exec $COMMAND $PREFIX/{} $HOME/{} \;
find .icons/      -maxdepth 1 -exec $COMMAND $PREFIX/{} $HOME/{} \;

$COMMAND $PREFIX/.zshenv   $HOME
$COMMAND $PREFIX/.xprofile $HOME

ln -sf /usr/bin/rofi $HOME/.local/bin/dmenu

.local/bin/dmenu_themes Dracula

mkdir -p $HOME/.config/zsh/plugs/
git clone "https://github.com/ael-code/zsh-colored-man-pages"    $HOME/.config/zsh/plugs/zsh-colored-man-pages
git clone "https://github.com/zsh-users/zsh-syntax-highlighting" $HOME/.config/zsh/plugs/zsh-syntax-highlighting
