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
    clisp
    racket
    opam
    ocaml
    jdk
    erlang
    elixir
    gh
    ghc
    gotools
    luajit
    stylish-haskell
    # not dev
    fd
    ripgrep
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
    ".config/alacritty/alacritty.yml".source = ./.config/alacritty/alacritty.yml;
    ".config/i3/config".source = ./.config/i3/config;
    ".config/i3status/config".source = ./.config/i3status/config;
    ".local/bin/rofi-power-menu".source = ./.local/bin/rofi-power-menu;
  };

  programs.home-manager.enable = true;
  home.stateVersion = "23.05"; # DONT'T CHANGE THIS MANUALLY!
}
