{ pkgs, my-pkgs, static-assets, secrets, ... }:
{
  imports = [
    (import ./programs/default.nix { inherit pkgs my-pkgs; })
    (import ./system/default.nix { inherit pkgs static-assets secrets; })
  ];
}
