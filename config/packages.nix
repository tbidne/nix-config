{ pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
    # core
    chromium
    firefox
    gimp
    mattermost
    mattermost-desktop
    slack
    teams
    thunderbird

    # dev
    dbeaver
    docker
    docker-compose
    git
    lua
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
    htop
    networkmanager-fortisslvpn
    openfortivpn
    pv
    unzip
    zip

    # misc
    nix-prefetch-git
    protonmail-bridge
  ];

  programs.gnupg.agent.enable = true;
}
