export GTK_USE_PORTAL=1

# fixes stuff with Java and the window manager
export _JAVA_AWT_WM_NONREPARENTING=1

export PATH="$PATH:$HOME/.cargo/bin:$HOME/go/bin:$HOME/.local/bin:$HOME/.luarocks/bin:$HOME/opt/bin"

# opam configuration
test -r $HOME/.opam/opam-init/init.sh && . $HOME/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
