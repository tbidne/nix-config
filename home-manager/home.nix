{ inputs }:
let
  hoogle = inputs.pkgs.haskellPackages.hoogle;
in
{
  imports = [
    (import ./programs/default.nix { inherit inputs; })
    (import ./system/default.nix { inherit inputs; })
  ];

  # virt-manager + QEMU/KVM
  #
  # https://nixos.wiki/wiki/Virt-manager
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  # If home-manager fails for a vague reason, try:
  #
  #     journalctl -eu home-manager-tommy.service

  home.packages = [
    hoogle
  ];

  # This ensures hoogle is always up-to-date. However, it takes 6-8 minutes
  # to generate every time, so this seems like a heavy penalty to impose on
  # every switch. Hence disabling it for now, but leaving the code as it is
  # useful if we ever want to do something like it in the future.
  #home.activation = {
  #  hoogleDatabase = inputs.hmLib.hm.dag.entryAfter [ "installPackages" ] ''
  #    ${hoogle}/bin/hoogle generate
  #  '';
  #};

  # NOTE: [Cachix]
  #
  # These files come from cachix. Since I am not currently using the cachix
  # exe, I want them blanked out of paranoia. If that changes, these lines
  # will have to be removed.
  home.file = {
    # Blanking these files to prevent outdated caches from being used.
    #
    # A better solution would be to prevent these files from being created.
    ".config/nix/netrc".text = "";
    ".config/nix/nix.conf".text = "";
  };

  home.stateVersion = "22.11";

  # Caused by warning:
  #
  #   The default value of `programs.swaylock.enable` has changed from
  #   `config.programs.swaylock.settings != { }` to `false`.
  #
  #   You are currently using the legacy default
  #   (`config.programs.swaylock.settings != { }`) because `home.stateVersion`
  #   is less than "23.05".
  #
  #   To silence this warning and keep legacy behavior, set:
  #     programs.swaylock.enable = config.programs.swaylock.settings != { };
  #
  #   To adopt the new default behavior, set:
  #     programs.swaylock.enable = false;
  programs.swaylock.enable = false;
}
