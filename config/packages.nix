{ pkgs, shell-run, ... }:

{
  environment.systemPackages = with pkgs; [
    # core
    chromium
    conky
    firefox
    gimp
    kitty
    pandoc
    texlive.combined.scheme-full

    # social
    element-desktop
    zoom-us

    # dev
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
