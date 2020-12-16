{ config, pkgs, ... }:

{
  imports =
    [ ./programs/git.nix
      ./programs/vscode.nix
      ./programs/zsh.nix
    ];

  nixpkgs.config.allowUnfree = true;

  # To make mouse pointer larger on HiDPI
  xsession.pointerCursor = {
    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ";
    size = 128;
  };
}
