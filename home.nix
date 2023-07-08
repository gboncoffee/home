{ config, pkgs, ... }:

{
  home.username = "gb";
  home.homeDirectory = "/home/gb";

  # some programs
  programs = {
    go.enable = true;
  };
  home.packages = with pkgs; [
    # dev
    tinycc
    stack
    nodejs
    clang
    rustup
    sbcl
    opam
    ocaml
    gh
    # not dev
    feh
    nnn
    flameshot
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qt5ct
    lxqt.lxqt-policykit
    pulsemixer
    dunst
    libnotify
    fd
    ripgrep
    mpdscribble
    pcmanfm-qt
  ];

  home.file = {
    ".bashrc".source = ./.bashrc;
    ".ghci".source = ./.ghci;
    ".profile".source = ./.profile;
    ".xprofile".source = ./.xprofile;
    ".local/bin/dmenu_bluetooth".source = ./.local/bin/dmenu_bluetooth;
    ".local/bin/dmenu_shutdown".source = ./.local/bin/dmenu_shutdown;
    ".local/bin/dmenu_web".source = ./.local/bin/dmenu_web;
    ".local/bin/luabatmon".source = ./.local/bin/luabatmon;
    ".local/bin/monitors".source = ./.local/bin/monitors;
    ".local/bin/setxbg".source = ./.local/bin/setxbg;
    ".local/bin/nnn".source = ./.local/bin/nnn;
    ".config/bookmarks".source = ./.config/bookmarks;
    ".config/chromium-flags.conf".source = ./.config/chromium-flags.conf;
    ".config/pyrc.py".source = ./.config/pyrc.py;
    ".config/user-dirs.locale".source = ./.config/user-dirs.locale;
    ".config/user-dirs.dirs".source = ./.config/user-dirs.dirs;
    ".config/cava/config".source = ./.config/cava/config;
    ".config/dunst/dunstrc".source = ./.config/dunst/dunstrc;
    ".config/git/config".source = ./.config/git/config;
    ".config/htop/htoprc".source = ./.config/htop/htoprc;
    ".config/mpd/mpd.conf".source = ./.config/mpd/mpd.conf;
    ".config/ncmpcpp/config".source = ./.config/ncmpcpp/config;
    ".config/ncmpcpp/bindings".source = ./.config/ncmpcpp/bindings;
    ".config/picom/picom.conf".source = ./.config/picom/picom.conf;
    ".config/polybar/config.ini".source = ./.config/polybar/config.ini;
    ".config/tmux/tmux.conf".source = ./.config/tmux/tmux.conf;
    ".config/xmonad/xmonad.hs".source = ./.config/xmonad/xmonad.hs;
  };

  xresources.properties = {
    "Xcursor.theme" = "Dracula-cursors";
  };

  qt.platformTheme = "qt5ct";
  programs.home-manager.enable = true;
  home.stateVersion = "23.05"; # DONT'T CHANGE THIS MANUALLY!
}
