{ compiler ? "ghc8104"
, pkgs ? import <nixpkgs> { }
}:

let
  haskellDeps = ps: with ps; [
    dbus
    X11
    xmonad
    xmonad-contrib
    xmonad-utils
    xmonad-wallpaper
  ];

  ghc = pkgs.haskell.packages.${compiler}.ghcWithPackages haskellDeps;
in pkgs.mkShell {
  buildInputs = [ ghc ];
}
