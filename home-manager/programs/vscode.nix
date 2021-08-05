{ pkgs, my-pkgs, ... }:

{
  programs.vscode = {
    enable = true;

    package = pkgs.vscodium;

    extensions = [
      my-pkgs.vscode-extensions.enkia.tokyo-night
      my-pkgs.vscode-extensions.meraymond.idris-vscode
      my-pkgs.vscode-extensions.arcticicestudio.nord-visual-studio-code

      pkgs.vscode-extensions.bbenoist.nix
      pkgs.vscode-extensions.coenraads.bracket-pair-colorizer-2
      pkgs.vscode-extensions.dracula-theme.theme-dracula
      pkgs.vscode-extensions.editorconfig.editorconfig
      pkgs.vscode-extensions.haskell.haskell
      pkgs.vscode-extensions.james-yu.latex-workshop
      pkgs.vscode-extensions.justusadam.language-haskell
      pkgs.vscode-extensions.mechatroner.rainbow-csv
      pkgs.vscode-extensions.ms-python.python
      pkgs.vscode-extensions.octref.vetur
      pkgs.vscode-extensions.streetsidesoftware.code-spell-checker
      pkgs.vscode-extensions.vscodevim.vim
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
      "workbench.activityBar.visible" = false;
      "workbench.colorTheme" = "Tokyo Night";
      "workbench.colorCustomizations" = {
        "activityBar.background" = "#242631";
        "editorGroupHeader.tabsBackground" = "#242631";
        "statusBar.background" = "#242631";
        "titleBar.activeBackground" = "#242631";
        "sideBar.background" = "#242631";
      };
      "editor.minimap.enabled" = false;
      "[haskell]" = {
        "editor.defaultFormatter" = "haskell.haskell";
      };

      # ignore spellcheck
      "cSpell.userWords" = [
        "asyn"
        "bifunctor"
        "bimap"
        "cmds"
        "concat"
        "curr"
        "desirements"
        "fmap"
        "foldr"
        "foldl"
        "hspec"
        "mempty"
        "monoid"
        "semigroup"
        "supremum"
        "typeclass"
        "unlift"
      ];
    };
  };
}
