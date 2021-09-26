{ compiler ? "ghc8107"
, pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/51bcdc4cdaac48535dabf0ad4642a66774c609ed.tar.gz") { }
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
