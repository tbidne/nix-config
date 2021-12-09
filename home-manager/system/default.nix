{ pkgs, ... }:
{
  imports = [
    (import ./xmonad/default.nix { inherit pkgs; })
  ];
}
