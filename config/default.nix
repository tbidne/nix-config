{ inputs }:
{
  imports = [
    ./bluetooth.nix
    ./cache.nix
    (import ./fonts.nix { inherit inputs; })
    ./iphone.nix
    (import ./packages.nix { inherit inputs; })
    ./postgresql.nix
    ./redshift.nix
    ./sys.nix
    ./user.nix
    ./vbox.nix
  ];
}
