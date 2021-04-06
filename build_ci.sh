#!/bin/bash

nix-shell -E 'with import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/ad47284f8b01f587e24a4f14e0f93126d8ebecda.tar.gz") {}; stdenv.mkDerivation { name = "try-build"; buildInputs = [ (nixos {}).nixos-rebuild ]; }' --command "nixos-rebuild dry-build"