{ inputs }:

{
  imports = [
    ./audio.nix
    ./boot.nix
    (import ./plasma.nix { inherit inputs; })
    ./mouse.nix
    ./network.nix
    ./swap.nix
  ];

  # misc

  # hardlinks to save space
  nix.settings.auto-optimise-store = true;

  security.sudo.extraConfig = ''
    Defaults timestamp_timeout=60
  '';

  # NOTE: The first time I added this, switching to the new profile failed.
  # I had to run 'sudo freshclam' (installation nonethless installed the
  # binaries). After that, switch succeeded.
  #
  # See https://discourse.nixos.org/t/how-to-use-clamav-in-nixos/19782/3
  #
  # TODO: Temporarily disabled: https://github.com/NixOS/nixpkgs/issues/325510
  services.clamav = {
    #daemon.enable = true;
    #updater.enable = true;
  };

  # automatic gc
  #
  # disabled for now as the auto gc is really inconvenient for some haskell
  # dev (e.g. nix-hs-tools)
  #
  #nix.gc = {
  #  automatic = true;
  #  dates = "weekly";
  #  options = "--delete-older-than 30d";
  #};
}
