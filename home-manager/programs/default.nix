{ pkgs, my-pkgs, ... }:
{
  imports = [
    ./bash.nix
    ./chromium.nix
    ./emacs/default.nix
    (import ./firefox.nix { inherit pkgs; })
    ./ghci.nix
    ./git.nix
    ./kitty/default.nix
    ./navi.nix
    ./neovim.nix
    ./shell-run.nix
    (import ./vscode.nix { inherit pkgs my-pkgs; })
  ];
}
