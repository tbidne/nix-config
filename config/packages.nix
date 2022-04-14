{ navi, pkgs, pythia, shell-run, ... }:

{
  environment.systemPackages = with pkgs; [
    # core
    chromium
    conky
    dunst
    firefox
    gimp
    google-chrome
    haruna
    thunderbird

    # doc editing
    libreoffice
    okular
    pandoc
    texlab # for lsp + latex
    texlive.combined.scheme-full

    # social
    discord
    element-desktop
    mattermost-desktop
    slack
    teams
    zoom-us

    # dev
    emacs
    dbeaver
    git
    insomnia
    lua
    neovim
    nginx
    nodejs
    onefetch
    ruby
    sqitchPg
    sqlite
    vim
    vscodium

    # my projects
    navi
    pythia
    shell-run

    # network utils
    traceroute
    whois

    # search utils
    fd
    fzf
    ripgrep
    silver-searcher

    # terminals
    kitty
    tmate
    tmux

    # misc utils
    acpi
    deadd-notification-center
    dig
    gnupg
    gotop
    libnotify
    lm_sensors
    lsof
    nix-prefetch-git
    openssl
    powerline
    pv
    tree
    unzip
    xclip
    zip
  ];

  programs.steam.enable = true;
  programs.gnupg.agent.enable = true;
}
