{ config, pkgs, ... }:

{
  imports =
    [ ./programs/chromium.nix
      ./programs/ghci.nix
      ./programs/git.nix
      ./programs/vscode.nix
      ./programs/zsh.nix

      ./programs/xmonad/default.nix
    ];
}
