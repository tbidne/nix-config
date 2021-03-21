#!/bin/bash

nix-shell -E 'with import <nixpkgs> {}; stdenv.mkDerivation { name = "try-build"; buildInputs = [ (nixos {}).nixos-rebuild ]; }' --command "nixos-rebuild dry-build"