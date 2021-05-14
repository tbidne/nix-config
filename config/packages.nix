{ pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
    # core
    chromium
    conky
    firefox
    gimp
    google-chrome
    pandoc
    texlive.combined.scheme-full
    thunderbird
    zoom-us

    # dev
    dbeaver
    git
    lua
    nginx
    ruby
    sqitchPg
    sqlite
    vim
    vscodium

    # doom emacs
    clang
    coreutils
    emacs
    fd
    ripgrep

    # haskell
    cabal-install
    cabal2nix
    stack

    # utils
    gnome3.zenity
    gnupg
    gotop
    htop
    networkmanager-fortisslvpn
    openfortivpn
    pv
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

  programs.gnupg.agent.enable = true;
}
