# Set $PATH to prefer user and Plan 9 applications.
PATH=${PATH%:$PLAN9/bin}
PATH="$HOME/.local/bin:$HOME/opt/bin:$PLAN9/bin:$HOME/go/bin:$PATH"
export PATH

# Set MANPATH so Unix man can search Plan 9 manpages
MANPATH="$PLAN9/man:/usr/share/man"
export MANPATH

# Plan 9 fonts
font=/mnt/font/NotoSansMono-Regular/16a/font
vfont=/mnt/font/NotoSans-Regular/16a/font
export font
export vfont
