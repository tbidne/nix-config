# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  yakuake-autostart = (pkgs.makeAutostartItem { name = "yakuake"; package = pkgs.yakuake; srcPrefix = "org.kde."; });
  home-manager = builtins.fetchGit {
    url = "https://github.com/rycee/home-manager.git";
    rev = "c1faa848c5224452660cd6d2e0f4bd3e8d206419";
  };
in
{
  imports =
    [ ./hardware-configuration.nix
      (import "${home-manager}/nixos")
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
  hardware.pulseaudio.package = pkgs.pulseaudioFull;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tommy = {
    name = "tommy";
    description = "Tommy Bidne";
    group = "users";
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" ]; # Enable ‘sudo’ for the user.
    uid = 1000;
    createHome = true;
    home = "/home/tommy";
    shell = "/run/current-system/sw/bin/zsh";
  };

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

  environment.variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
  };

  # https://www.sven.de/dpi/
  services.xserver.dpi = 314;

  fonts.fonts = with pkgs; [
    hasklig ];

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_12;
    authentication = pkgs.lib.mkForce ''
    local all all trust
    host  all all 127.0.0.1/32 trust
    host  all all ::1/128      trust
    host  all all 0.0.0.0/0    trust
    '';
  };

  location.provider = "manual";
  location.latitude = 38.89511;
  location.longitude = -77.03637;

  services.redshift = {
    enable = true;
    brightness.day = "1";
    brightness.night = "0.5";
    temperature.day = 5500;
    temperature.night = 3700;
  };

  home-manager.users.tommy = import ./home.nix;

  programs.zsh.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  nix.binaryCaches = [ "https://nixcache.reflex-frp.org" "https://cache.nixos.org" "https://shpadoinkle.cachix.org" ];
  nix.binaryCachePublicKeys = [ "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI=" "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" "shpadoinkle.cachix.org-1:aRltE7Yto3ArhZyVjsyqWh1hmcCf27pYSmO1dPaadZ8=" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
}
