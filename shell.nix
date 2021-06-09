{ compiler ? "ghc8104"
, pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/d3ba49889a76539ea0f7d7285b203e7f81326ded.tar.gz") { }
}:

let
  haskellDeps = ps: with ps; [
    dbus
    haskell-language-server
    X11
    xmonad
    xmonad-contrib
    xmonad-utils
    xmonad-wallpaper
  ];

  ghc = pkgs.haskell.packages.${compiler}.ghcWithPackages haskellDeps;
in
pkgs.mkShell {
  buildInputs = [ ghc pkgs.nixpkgs-fmt ];
}
