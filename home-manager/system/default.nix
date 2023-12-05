{ inputs }:
{
  imports = [
    (import ./gnome/default.nix { inherit inputs; })
  ];
}
