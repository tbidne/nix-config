{ pkgs, my-pkgs, ... }:
{
  imports = [
    ./chromium.nix
    ./emacs/default.nix
    (import ./firefox.nix { inherit pkgs; })
    ./ghci.nix
    ./git.nix
    ./kitty/default.nix
    ./neovim.nix
    (import ./vscode.nix { inherit pkgs my-pkgs; })
    ./zsh.nix
  ];
}
