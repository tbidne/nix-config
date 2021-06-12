{ config, pkgs, ... }:

{
  imports =
    [
      ./programs/chromium.nix
      ./programs/ghci.nix
      ./programs/git.nix
      ./programs/neovim.nix
      ./programs/vscode.nix
      ./programs/xmonad/default.nix
      ./programs/zsh.nix
    ];
}
