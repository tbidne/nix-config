{ config, pkgs, ... }:

let
  unstableTarball = builtins.fetchGit {
    url = "https://github.com/NixOS/nixpkgs.git";
    ref = "nixos-unstable";
    rev = "71d12ee415a131e277149d05fefb5d7e0d0707d8";
  };
  myTarball = builtins.fetchGit {
    url = "https://github.com/tbidne/nixpkgs.git";
    ref = "develop";
    rev = "8180725d01ea59a22a40f5e9e19bba2c0609bce8";
  };
in
{
  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
      mine = import myTarball {
        config = config.nixpkgs.config;
      };
    };
  };

  programs.vscode = {
    enable = true;

    package = pkgs.vscodium;

    extensions = [
      pkgs.vscode-extensions.bbenoist.Nix
      pkgs.vscode-extensions.justusadam.language-haskell
      pkgs.unstable.vscode-extensions.haskell.haskell
      pkgs.mine.vscode-extensions.coenraads.bracket-pair-colorizer-2
      pkgs.mine.vscode-extensions.mechatroner.rainbow-csv
    ];
    userSettings = {
      "editor.wordWrapColumn" = 80;
      "editor.renderWhitespace" = "boundary";
      "breadcrumbs.enabled" = true;
      "editor.fontLigatures" = true;
      "editor.fontFamily" = "Hasklig, Menlo, Menlo, Monaco, 'Courier New', monospace";
      "editor.wordWrap"= "on";
    };
  };
}