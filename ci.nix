{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/6933d068c5d2fcff398e802f7c4e271bbdab6705.tar.gz") {}
}:

pkgs.stdenv.mkDerivation {
  name = "try-build"; buildInputs = [ (pkgs.nixos {}).nixos-rebuild ];
}
