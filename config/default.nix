{ inputs }:
{
  imports =
    [
      ./bluetooth.nix
      ./cache.nix
      (import ./fonts.nix { inherit inputs; })
      (import ./packages.nix { inherit inputs; })
      ./postgresql.nix
      ./redshift.nix
      ./sys.nix
      ./user.nix
      ./vbox.nix
    ];
}
