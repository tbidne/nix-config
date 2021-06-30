{ secrets, ... }:

{
  imports =
    [
      ./better-lock-screen.nix
      ./dunst.nix
      ./kitty/default.nix
      ./picom.nix
      (import ./polybar/default.nix { inherit secrets; })
      ./rofi/default.nix
      ./xmonad.nix
    ];
}
