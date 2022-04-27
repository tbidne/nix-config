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
}
