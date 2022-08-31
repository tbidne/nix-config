{ inputs }:
{
  imports = [
    ./bash.nix
    ./chromium.nix
    ./emacs/default.nix
    (import ./firefox.nix { inherit inputs; })
    ./ghci.nix
    ./git.nix
    (import ./kitty/default.nix { inherit inputs; })
    ./navi.nix
    ./neovim.nix
    (import ./shrun/default.nix { inherit inputs; })
    (import ./vscode.nix { inherit inputs; })
  ];
}
