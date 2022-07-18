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
  ide-purescript = buildVscodeExt {
    mktplcRef = {
      name = "ide-purescript";
      publisher = "nwolverson";
      version = "0.25.12";
      sha256 = "1f9064w18wwp3iy8ciajad8vlshnzyhnqy8h516k0j5bflz781mn";
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
  language-purescript = buildVscodeExt {
    mktplcRef = {
      name = "language-purescript";
      publisher = "nwolverson";
      version = "0.2.8";
      sha256 = "1nhzvjwxld53mlaflf8idyjj18r1dzdys9ygy86095g7gc4b1qys";
    };
    meta = { license = licenses.mit; };
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
    ide-purescript
    idris-vscode
    language-purescript
    tokyo-night
  ];
in
{
  programs.vscode = {
    enable = true;
    package = inputs.pkgs.vscodium;

    extensions = with inputs.pkgs.vscode-extensions; [
      arcticicestudio.nord-visual-studio-code
      bbenoist.nix
      bungcip.better-toml
      dracula-theme.theme-dracula
      editorconfig.editorconfig
      haskell.haskell
      james-yu.latex-workshop
      jnoortheen.nix-ide
      justusadam.language-haskell
      mechatroner.rainbow-csv
      ms-python.python
      octref.vetur
      streetsidesoftware.code-spell-checker
    ] ++ externalExts;
    userSettings = {
      "breadcrumbs.enabled" = true;
      "editor.fontLigatures" = true;
      "editor.fontFamily" = "Hasklig, Menlo, Menlo, Monaco, 'Courier New', monospace";
      "editor.minimap.enabled" = false;
      "editor.renderWhitespace" = "boundary";
      "editor.tabSize" = 2;
      "editor.wordWrap" = "on";
      "editor.wordWrapColumn" = 80;
      "editor.bracketPairColorization.enabled" = true;
      "editor.guides.bracketPairs" = "active";
      "editor.unicodeHighlight.allowedCharacters" = {
        "α" = true;
        "γ" = true;
      };
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
      "[haskell]" = {
        "editor.defaultFormatter" = "haskell.haskell";
      };

      # ignore spellcheck
      "cSpell.userWords" = haskellWords ++ miscWords;
    };
  };
}
