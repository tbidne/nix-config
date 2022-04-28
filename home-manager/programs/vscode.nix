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

  buildVscodeExt = inputs.pkgs.vscode-utils.buildVscodeMarketplaceExtension;
  licenses = inputs.pkgs.lib.licenses;

  agda-mode = buildVscodeExt {
    mktplcRef = {
      name = "agda-mode";
      publisher = "banacorn";
      version = "0.3.7";
      sha256 = "0hmldbyldr4h53g5ifrk5n5504yzhbq5hjh087id6jbjkp41gs9b";
    };
    meta = { license = licenses.mit; };
  };
  idris-vscode = buildVscodeExt {
    mktplcRef = {
      publisher = "meraymond";
      name = "idris-vscode";
      version = "0.0.9";
      sha256 = "16n8bi34alpyybm90h3nn1rdw6r6s1xdyx11dbggr6fwdps70mv9";
    };
    meta = {
      changelog = "https://marketplace.visualstudio.com/items/meraymond.idris-vscode/changelog";
      description = "Language support for Idris and Idris 2.";
      downloadPage = "https://marketplace.visualstudio.com/items?itemName=meraymond.idris-vscode";
      homepage = "https://github.com/meraymond2/idris-vscode";
      license = licenses.mit;
    };
  };
  tokyo-night = buildVscodeExt {
    mktplcRef = {
      name = "tokyo-night";
      publisher = "enkia";
      version = "0.7.9";
      sha256 = "1yci2krmmxz4w105c9mjzhv8r0wbpf3k603rz5p0syq1b7g9vsfv";
    };
    meta = { license = licenses.mit; };
  };

  externalExts = [
    agda-mode
    idris-vscode
    tokyo-night
  ];
in
{
  programs.vscode = {
    enable = true;

    package = inputs.pkgs.vscodium;

    extensions = [
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
    ] ++ externalExts;
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
