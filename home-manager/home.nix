{ pkgs, my-pkgs, ... }:
{
  imports = [
    (import ./programs/default.nix { inherit pkgs my-pkgs; })
    (import ./system/default.nix { inherit pkgs; })
  ];
}
