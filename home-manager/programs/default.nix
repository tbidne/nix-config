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
    ./shrun/default.nix
    (import ./vscode.nix { inherit inputs; })
  ];
}
