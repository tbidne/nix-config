{ inputs }:

{
  imports =
    [
      ./audio.nix
      ./boot.nix
      ./mouse.nix
      ./network.nix
      ./swap.nix
      (import ./xmonad.nix { inherit inputs; })
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
