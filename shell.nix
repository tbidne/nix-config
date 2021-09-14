{ compiler ? "ghc8107"
, pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/364b5555ee04bf61ee0075a3adab4c9351a8d38c.tar.gz") { }
}:

let
  haskellDeps = ps: with ps; [
    dbus
    haskell-language-server
    hlint
    X11
    xmonad
    xmonad-contrib
    xmonad-utils
    xmonad-wallpaper
  ];

  haskellOtherDeps = with pkgs; [
    haskellPackages.ormolu
  ];

  otherDeps = with pkgs; [
    nixpkgs-fmt
  ];

  ghc = pkgs.haskell.packages.${compiler}.ghcWithPackages haskellDeps;
in
pkgs.mkShell {
  buildInputs =
    [ ghc ]
    ++ haskellOtherDeps
    ++ otherDeps;
}
