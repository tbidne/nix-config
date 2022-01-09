{ pkgs, shell-run, navi, ... }:

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
    shell-run
    navi

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
    deadd-notification-center
    dig
    gnupg
    gotop
    libnotify
    lm_sensors
    lsof
    nix-prefetch-git
    openssl
    pv
    tree
    unzip
    xclip
    zip
  ];

  programs.steam.enable = true;
  programs.gnupg.agent.enable = true;
}
