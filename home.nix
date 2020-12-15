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

  programs.git = {
    enable = true;
    userName = "Tommy Bidne";
    extraConfig = {
      pull.ff = "only";
      push.default = "simple";
      diff.tool = "kdiff3";
      merge.tool = "kdiff3";
    };
    aliases = {
      s = "status";
      gad = "add -A";
      co = "checkout";
      cob = "checkout -b";
      count = "count-objects -vH";
      ft = "fetch --prune";
      mst = "merge origin/master --ff-only";
      log-mst = "log origin/master";
      log-mst-me = "log origin/master --author='Tommy Bidne'";
      log-me = "log --author='Tommy Bidne'";
      df = "diff";
      dfc = "diff --cached";
      dft = "difftool";
      dftc = "difftool --cached";
    };
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

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    history.extended = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git-extras"
        "git"
        "gitfast"
      ];
      theme = "avit";
    };
  };
}
