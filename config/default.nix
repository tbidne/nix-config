{ pkgs, system, ringbearer, shell-run }:
{
  imports =
    [
      ./bluetooth.nix
      ./cache.nix
      (import ./fonts.nix { inherit pkgs system ringbearer; })
      (import ./packages.nix { inherit pkgs shell-run; })
      ./postgresql.nix
      ./redshift.nix
      ./sys.nix
      ./user.nix
    ];
}
