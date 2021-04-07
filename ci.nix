{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/3d1a7716d7f1fccbd7d30ab3b2ed3db831f43bde.tar.gz") {}
}:

pkgs.stdenv.mkDerivation {
  name = "try-build"; buildInputs = [ (pkgs.nixos {}).nixos-rebuild ];
}
