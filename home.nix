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
    fd
    ripgrep
    mpd
    cantata
  ];

  home.file = {
    ".bashrc".source = ./.bashrc;
    ".ghci".source = ./.ghci;
    ".profile".source = ./.profile;
    ".xprofile".source = ./.xprofile;
    ".config/pyrc.py".source = ./.config/pyrc.py;
    ".config/git/config".source = ./.config/git/config;
    ".config/htop/htoprc".source = ./.config/htop/htoprc;
    ".config/tmux/tmux.conf".source = ./.config/tmux/tmux.conf;
  };

  xresources.properties = {
    "Xcursor.theme" = "Dracula-cursors";
  };

  programs.home-manager.enable = true;
  home.stateVersion = "23.05"; # DONT'T CHANGE THIS MANUALLY!
}
