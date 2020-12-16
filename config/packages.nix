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
    firefox
    gimp
    google-chrome
    mattermost
    mattermost-desktop
    slack
    teams
    teamspeak_client

    # dev
    dbeaver
    docker
    docker-compose
    git
    kdiff3
    ruby
    sqitchPg
    vscode

    # haskell
    cabal-install
    cabal2nix
    stack

    # utils
    gnupg
    home-manager
    networkmanager-fortisslvpn
    openfortivpn
    unzip
    yakuake
    yakuake-autostart
    zip

    # misc
    nix-prefetch-git
    plasma5.plasma-browser-integration
  ];

  programs.gnupg.agent.enable = true;

  services.blueman.enable = true;
}