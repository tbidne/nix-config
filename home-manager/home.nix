{ config, pkgs, ... }:

{
  imports =
    [ # dot files
      ./dotfiles/ghci.nix
      ./dotfiles/konsole.nix
      
      # program configs
      ./programs/chromium.nix
      ./programs/git.nix
      ./programs/vscode.nix
      ./programs/zsh.nix
    ];

  nixpkgs.config.allowUnfree = true;
}
