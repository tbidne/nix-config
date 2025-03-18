{ inputs }:
{
  imports = [
    ./bash.nix
    ./charon/default.nix
    ./chromium.nix
    (import ./firefox.nix { inherit inputs; })
    ./ghci.nix
    ./git.nix
    (import ./kitty/default.nix { inherit inputs; })
    (import ./navi/default.nix { inherit inputs; })
    ./pythia/default.nix
    ./kairos/default.nix
    (import ./shrun/default.nix { inherit inputs; })
    (import ./vscode.nix { inherit inputs; })
    ./zoom/default.nix
  ];
}
