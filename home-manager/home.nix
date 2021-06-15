{ pkgs, my-pkgs, secrets, ... }:

{
  imports =
    [
      ./programs/chromium.nix
      ./programs/ghci.nix
      ./programs/git.nix
      ./programs/neovim.nix
      (import ./programs/vscode.nix { inherit pkgs my-pkgs; })
      (import ./programs/xmonad/default.nix { inherit secrets; })
      ./programs/zsh.nix
    ];
}
