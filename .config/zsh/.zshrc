# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle ':completion:*' menu select=1
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle :compinstall filename '/home/gg/.config/zsh/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE='/home/gg/.local/share/zsh/histfile'
HISTSIZE=1000
SAVEHIST=1000
setopt autocd beep notify
unsetopt extendedglob nomatch
bindkey -v
# End of lines configured by zsh-newuser-install

#
# Custom
#
zmodload zsh/complist

# 
# keys
#
# scroll suggestions backwards with Shift-Tab
bindkey -M menuselect '^[[Z' reverse-menu-complete
# history search
bindkey -M viins '^j' history-search-forward
bindkey -M viins '^k' history-search-backward
# readline on Vi mode
bindkey -M viins '^a' beginning-of-line
bindkey -M viins '^e' end-of-line
bindkey -M viins '^d' delete-char
bindkey -M viins '^f' forward-char
bindkey -M viins '^b' backward-char
bindkey -M viins '^w' backward-kill-word
# fix Ctrl-C
bindkey -M vicmd '^c' self-insert
bindkey -M visual '^c' self-insert

# prompt
PROMPT='%F{magenta}%m%f:%B%F{blue}%2~%f%b λ '

#
# aliases
#

# common commands
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias hi='highlight -O ansi'
# downloads and records
alias music-dl='yt-dlp -i -x --audio-format mp3'
alias convert-to-web='ffmpeg -i out.mp4 -c:v libx264 -crf 20 -preset slow -vf format=yuv420p -c:a aac -movflags +faststart output.mp4'
# command configs
alias cbonsai='cbonsai -l -S -i'
alias tty-clock='tty-clock -s'
# other
alias fuck='sudo $(fc -ln -1)'

# print exit value if != 0
setopt PRINT_EXIT_VALUE

# source plugins
PLUGS_HOME=$HOME"/.config/zsh/plugs"
source $PLUGS_HOME"/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh"

# jokes haha
echo "Welcome to zsh, the unfriendly interactive shell"
