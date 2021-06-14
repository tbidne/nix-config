{ pkgs, secrets, ... }:

{
  imports =
    [
      ./programs/chromium.nix
      ./programs/ghci.nix
      ./programs/git.nix
      ./programs/neovim.nix
      ./programs/vscode.nix
      (import ./programs/xmonad/default.nix { inherit secrets; })
      ./programs/zsh.nix
    ];
}
