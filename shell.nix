{ compiler ? "ghc8101"
, pkgs ? import <nixpkgs> { }
}:

let
  haskellDeps = ps: with ps; [
    dbus
    xmonad
    xmonad-contrib
    xmonad-utils
    xmonad-wallpaper
  ];

  ghc = pkgs.haskell.packages.${compiler}.ghcWithPackages haskellDeps;
in pkgs.mkShell {
  buildInputs = [ ghc ];
}
