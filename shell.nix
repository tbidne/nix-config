{ compiler ? "ghc8104"
, pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/6ef4f522d63f22b40004319778761040d3197390.tar.gz") { }
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
