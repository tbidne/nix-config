{ pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
    # core
    chromium
    firefox
    gimp
    pandoc
    texlive.combined.scheme-full
    thunderbird

    # dev
    dbeaver
    git
    lua
    nginx
    ruby
    sqitchPg
    vim
    vscodium

    # haskell
    cabal-install
    cabal2nix
    stack

    # utils
    gnupg
    gotop
    htop
    networkmanager-fortisslvpn
    openfortivpn
    pv
    traceroute
    tty-clock
    unzip
    whois
    zip

    # misc
    nix-prefetch-git
  ];

  programs.gnupg.agent.enable = true;
}
