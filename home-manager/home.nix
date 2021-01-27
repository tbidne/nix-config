{ config, pkgs, ... }:

{
  imports =
    [ #./rofi.nix
      ./ghci.nix
      ./konsole.nix
      ./xmonad.nix
      ./vscode.nix
      ./zsh.nix
    ];

  nixpkgs.config.allowUnfree = true;
}
