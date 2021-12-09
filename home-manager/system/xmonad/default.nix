{ pkgs, ... }:

{
  imports =
    [
      ./better-lock-screen.nix
      ./deadd/default.nix
      ./picom.nix
      ./polybar/default.nix
      ./rofi/default.nix
      ./xmonad.nix
    ];
}
