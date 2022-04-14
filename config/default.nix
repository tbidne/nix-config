{ impact
, navi
, pkgs
, pythia
, ringbearer
, shell-run
, system
}:
{
  imports =
    [
      ./bluetooth.nix
      ./cache.nix
      (import ./fonts.nix { inherit impact pkgs ringbearer system; })
      (import ./packages.nix { inherit navi pkgs pythia shell-run; })
      ./postgresql.nix
      ./redshift.nix
      ./sys.nix
      ./user.nix
      ./vbox.nix
    ];
}
