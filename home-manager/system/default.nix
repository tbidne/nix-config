{ inputs }:
{
  imports = [
    (import ./plasma/default.nix { inherit inputs; })
  ];
}
