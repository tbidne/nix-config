{ pkgs, shell-run, ... }:

{
  environment.systemPackages = with pkgs; [
    # core
    chromium
    conky
    dunst
    firefox
    gimp
    kitty

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
    zoom-us

    # dev
    emacs
    dbeaver
    git
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

    # utils
    fd
    fzf
    gnupg
    gotop
    pv
    ripgrep
    silver-searcher
    tmate
    tmux
    traceroute
    tree
    tty-clock
    unzip
    whois
    zip

    # misc
    nix-prefetch-git
  ];

  programs.steam.enable = true;
  programs.gnupg.agent.enable = true;
}
