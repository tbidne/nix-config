#!/bin/bash

mkdir -p ./app/nixos
echo "{}" > ./app/nixos/interos.nix

nix-shell -E 'with import <nixpkgs> {}; stdenv.mkDerivation { name = "try-build"; buildInputs = [ (nixos {}).nixos-rebuild ]; }' --command "nixos-rebuild dry-build"