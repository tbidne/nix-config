{ config, pkgs, ... }:

let
  unstableTarball = builtins.fetchGit {
    url = "https://github.com/NixOS/nixpkgs.git";
    ref = "nixos-unstable";
    rev = "71478e6fe4b3330d55b3a7c6b8462845a8bdc484";
  };
in
{
  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
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
      pkgs.unstable.vscode-extensions.coenraads.bracket-pair-colorizer-2
      pkgs.unstable.vscode-extensions.mechatroner.rainbow-csv
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
