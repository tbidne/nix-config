{ pkgs, ... }:

let
  yakuake-autostart = (pkgs.makeAutostartItem {
    name = "yakuake";
    package = pkgs.yakuake;
    srcPrefix = "org.kde.";
  });
in
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
    kdiff3
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
    unzip
    yakuake
    yakuake-autostart
    zip

    # misc
    conky
    nix-prefetch-git
    plasma5.plasma-browser-integration
    protonmail-bridge
  ];

  programs.gnupg.agent.enable = true;
}
