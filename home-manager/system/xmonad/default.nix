{ pkgs, static-assets, secrets, ... }:

{
  imports =
    [
      ./better-lock-screen.nix
      (import ./dunst.nix { inherit pkgs static-assets; })
      ./picom.nix
      (import ./polybar/default.nix { inherit secrets; })
      ./rofi/default.nix
      ./xmonad.nix
    ];
}
