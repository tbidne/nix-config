{ inputs }:
{
  imports = [
    (import ./xmonad/default.nix { inherit inputs; })
  ];
}
