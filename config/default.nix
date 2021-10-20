{ pkgs, system, ringbearer, impact, shell-run }:
{
  imports =
    [
      ./bluetooth.nix
      ./cache.nix
      (import ./fonts.nix { inherit pkgs system ringbearer impact; })
      (import ./packages.nix { inherit pkgs shell-run; })
      ./postgresql.nix
      ./redshift.nix
      ./sys.nix
      ./user.nix
      ./vbox.nix
    ];
}
