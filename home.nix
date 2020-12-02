{ config, pkgs, ... }:

let
  unstableTarball =
    fetchTarball
      https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz;
in
{
  nixpkgs.config.allowUnfree = true;

  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };

  accounts.email = {
    accounts = {
      gmail = {
        address = "tbidne@gmail.com";
        userName = "tbidne@gmail.com";
        flavor = "gmail.com";
        primary = true;
        realName = "Tommy Bidne";
      };
      platonic-systems = {
        address = "tommy.bidne@platonic.systems";
        userName = "tommy.bidne@platonic.systems";
        flavor = "gmail.com";
        primary = false;
        realName = "Tommy Bidne";
      };
    };
  };

  programs.git = {
    enable = true;
    userName = "Tommy Bidne";
    userEmail = "tbidne@gmail.com";
  };

  programs.vscode = {
    enable = true;

    extensions = [
      pkgs.vscode-extensions.bbenoist.Nix
      pkgs.vscode-extensions.justusadam.language-haskell
      pkgs.unstable.vscode-extensions.haskell.haskell
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

  programs.firefox = {
    enable = true;
  };
}
