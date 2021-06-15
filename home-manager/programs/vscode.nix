{ pkgs, my-pkgs, ... }:

{
  programs.vscode = {
    enable = true;

    package = pkgs.vscodium;

    extensions = [
      my-pkgs.vscode-extensions.meraymond.idris-vscode

      pkgs.vscode-extensions.bbenoist.Nix
      pkgs.vscode-extensions.coenraads.bracket-pair-colorizer-2
      pkgs.vscode-extensions.dracula-theme.theme-dracula
      pkgs.vscode-extensions.editorconfig.editorconfig
      pkgs.vscode-extensions.haskell.haskell
      pkgs.vscode-extensions.justusadam.language-haskell
      pkgs.vscode-extensions.mechatroner.rainbow-csv
      pkgs.vscode-extensions.ms-python.python
      pkgs.vscode-extensions.streetsidesoftware.code-spell-checker
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
      ];
    };
  };
}
