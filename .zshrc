
# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}' 'l:|=* r:|=*'
zstyle ':completion:*' menu select=1
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle :compinstall filename '/home/gb/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd notify
bindkey -e
# End of lines configured by zsh-newuser-install

# sane word chars (sorry but bash does then the right way)
autoload -U select-word-style
select-word-style bash

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'

    alias ip='ip --color=auto'
fi

setopt print_exit_value
NEWLINE=$'\n'

PROMPT="${NEWLINE}%B%F{green}[%n@%m:%~$]%f%b "

alias music-dl='yt-dlp -i -x --audio-format mp3'
alias convert-to-web='ffmpeg -i out.mp4 -c:v libx264 -crf 20 -preset slow -vf format=yuv420p -c:a aac -movflags +faststart output.mp4'
alias fuck='sudo $(fc -ln -1)'
alias ocaml='rlwrap ocaml'

# if on kitty, create the alias for ssh
[ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"
