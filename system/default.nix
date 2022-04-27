{ pkgs, xmonad-packages, ... }:

{
  imports =
    [
      ./audio.nix
      ./boot.nix
      ./mouse.nix
      ./network.nix
      #./plasma.nix
      ./swap.nix
      (import ./xmonad.nix { inherit pkgs xmonad-packages; })
    ];
}
