{ inputs }:
{
  imports = [
    #(import ./gnome/conky.nix { inherit inputs; })
    (import ./gnome/default.nix { inherit inputs; })
  ];
}
