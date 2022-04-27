{ inputs }:
{
  imports = [
    (import ./programs/default.nix { inherit inputs; })
    (import ./system/default.nix { inherit inputs; })
  ];
}
