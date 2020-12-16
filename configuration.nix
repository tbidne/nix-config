# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  home-manager = builtins.fetchGit {
    url = "https://github.com/rycee/home-manager.git";
    rev = "c1faa848c5224452660cd6d2e0f4bd3e8d206419";
  };
in
{
  imports =
    [ # system
      ./hardware-configuration.nix
      ./system/audio.nix
      ./system/boot.nix
      ./system/desktopEnv.nix
      ./system/network.nix

      # general config
      ./config/bluetooth.nix
      ./config/cache.nix
      ./config/dpi.nix
      ./config/packages.nix
      ./config/postgresql.nix
      ./config/redshift.nix
      ./config/sys.nix
      ./config/user.nix

      # home manager
      (import "${home-manager}/nixos")
      ./app/nixos/interos.nix
    ];

  nixpkgs.config.allowUnfree = true;

  home-manager.users.tommy = import ./home-manager/home.nix;  

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
}
