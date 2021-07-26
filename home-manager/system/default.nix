{ pkgs, static-assets, secrets, ... }:
{
  imports = [
    (import ./xmonad/default.nix { inherit pkgs static-assets secrets; })
  ];
}
