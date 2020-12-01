# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  yakuake_autostart = (pkgs.makeAutostartItem { name = "yakuake"; package = pkgs.yakuake; srcPrefix = "org.kde.";  });
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import "${builtins.fetchTarball https://github.com/rycee/home-manager/archive/master.tar.gz}/nixos")
    ];

  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s3.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  # Enable the Plasma 5 Desktop Environment.
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tommy = {
    name = "tommy";
    description = "Tommy Bidne";
    group = "users";
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    uid = 1000;
    createHome = true;
    home = "/home/tommy";
    shell = "/run/current-system/sw/bin/bash";
  };

  environment.systemPackages = with pkgs; [
    # core
    firefox
    google-chrome
    mattermost
    slack

    # email
    kdeApplications.kmail
    kdeApplications.kmail-account-wizard
    kdeApplications.kmailtransport
    accounts-qt
    kmail

    # dev
    dbeaver
    git
    postgresql
    vscode

    # haskell
    cabal-install
    cabal2nix
    stack

    # utils
    gnupg
    home-manager
    openfortivpn
    yakuake
    yakuake_autostart

    # misc
    nix-prefetch-git
    pinentry
    pinentry-qt
  ];

  environment.variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
  };

  services.xserver.dpi = 227;

  fonts.fonts = with pkgs; [
    hasklig  ];

  location.latitude = 38.9072;
  location.longitude = 77.0369;

  services.redshift = {
    enable = true;
    brightness.day = "1";
    brightness.night = "0.5";
    temperature.day = 5500;
    temperature.night = 3700;
  };

  home-manager.users.tommy = import ./home.nix;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
}