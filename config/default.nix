{ pkgs, system, ringbearer }:
{
  imports =
    [
      ./bluetooth.nix
      ./cache.nix
      (import ./fonts.nix { inherit pkgs system ringbearer; })
      ./packages.nix
      ./postgresql.nix
      ./redshift.nix
      ./sys.nix
      ./user.nix
    ];
}
