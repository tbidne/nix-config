{ config, pkgs, ... }:

let
  unstableTarball = builtins.fetchGit {
    url = "https://github.com/NixOS/nixpkgs.git";
    ref = "nixos-unstable";
    rev = "71478e6fe4b3330d55b3a7c6b8462845a8bdc484";
  };
  masterTarbell = builtins.fetchGit {
    url = "https://github.com/tbidne/nixpkgs.git";
    ref = "master";
    rev = "a786e326c3fc54d0bb02e2a592a0a492e325dde2";
  };
in
{
  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
      master = import masterTarbell {
        config = config.nixpkgs.config;
      };
    };
  };

  programs.vscode = {
    enable = true;

    package = pkgs.vscodium;

    extensions = [
      pkgs.master.vscode-extensions.dracula-theme.theme-dracula
      pkgs.vscode-extensions.bbenoist.Nix
      pkgs.vscode-extensions.justusadam.language-haskell
      pkgs.unstable.vscode-extensions.haskell.haskell
      pkgs.unstable.vscode-extensions.coenraads.bracket-pair-colorizer-2
      pkgs.unstable.vscode-extensions.mechatroner.rainbow-csv
    ];
    userSettings = {
      "breadcrumbs.enabled" = true;
      "editor.fontLigatures" = true;
      "editor.fontFamily" = "Hasklig, Menlo, Menlo, Monaco, 'Courier New', monospace";
      "editor.renderWhitespace" = "boundary";
      "editor.tabSize" = 2;
      "editor.wordWrap" = "on";
      "editor.wordWrapColumn" = 80;
      "update.mode" = "manual";
      "window.menuBarVisibility" = "toggle";
      "workbench.colorTheme" = "Dracula";
    };
  };
}
