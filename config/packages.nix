{ pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
    # core
    chromium
    firefox
    gimp
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
    home-manager
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
    protonmail-bridge
  ];

  programs.gnupg.agent.enable = true;
}
