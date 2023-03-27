{ inputs }:

{
  imports =
    [
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
