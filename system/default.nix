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
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
}
