{ inputs }:

let
  haskellWords = [
    "anyclass"
    "bifunctor"
    "bimap"
    "concat"
    "doctest"
    "fmap"
    "foldr"
    "foldl"
    "hashable"
    "hspec"
    "mempty"
    "monoid"
    "optparse"
    "semigroup"
    "stackage"
    "stringbuilder"
    "typeclass"
    "unlift"
    "unlifteddatatypes"
  ];
  miscWords = [
    "supremum"
  ];
  my-pkgs = import inputs.my-nixpkgs {
    system = inputs.system;
    config = { allowUnfree = true; };
  };
in
{
  programs.vscode = {
    enable = true;

    package = inputs.pkgs.vscodium;

    extensions = [
      my-pkgs.vscode-extensions.banacorn.agda-mode
      my-pkgs.vscode-extensions.enkia.tokyo-night
      my-pkgs.vscode-extensions.meraymond.idris-vscode
      inputs.pkgs.vscode-extensions.arcticicestudio.nord-visual-studio-code
      inputs.pkgs.vscode-extensions.bbenoist.nix
      inputs.pkgs.vscode-extensions.dracula-theme.theme-dracula
      inputs.pkgs.vscode-extensions.editorconfig.editorconfig
      inputs.pkgs.vscode-extensions.haskell.haskell
      inputs.pkgs.vscode-extensions.james-yu.latex-workshop
      inputs.pkgs.vscode-extensions.jnoortheen.nix-ide
      inputs.pkgs.vscode-extensions.justusadam.language-haskell
      inputs.pkgs.vscode-extensions.mechatroner.rainbow-csv
      inputs.pkgs.vscode-extensions.ms-python.python
      inputs.pkgs.vscode-extensions.octref.vetur
      inputs.pkgs.vscode-extensions.streetsidesoftware.code-spell-checker
    ];
    userSettings = {
      "breadcrumbs.enabled" = true;
      "editor.fontLigatures" = true;
      "editor.fontFamily" = "Hasklig, Menlo, Menlo, Monaco, 'Courier New', monospace";
      "editor.renderWhitespace" = "boundary";
      "editor.tabSize" = 2;
      "editor.wordWrap" = "on";
      "editor.wordWrapColumn" = 80;
      "editor.bracketPairColorization.enabled" = true;
      "editor.guides.bracketPairs" = "active";
      "update.mode" = "manual";
      "window.menuBarVisibility" = "toggle";
      "workbench.activityBar.visible" = true;
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
      "cSpell.userWords" = haskellWords ++ miscWords;
    };
  };
}
