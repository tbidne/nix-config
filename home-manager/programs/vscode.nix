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
  haskell-spotlight = buildVscodeExt {
    mktplcRef = {
      name = "haskell-spotlight";
      publisher = "visortelle";
      version = "0.0.3";
      sha256 = "sha256-pHrGjAwb5gWxzCtsUMU6+zdQTI8aMxiwtQi4fc9JH9g=";
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
  lisp-syntax = buildVscodeExt {
    mktplcRef = {
      name = "Lisp-Syntax";
      publisher = "slbtty";
      version = "0.2.1";
      sha256 = "sha256-Jos0MJBuFlbfyAK/w51+rblslNq+pHN8gl1T0/UcP0Q=";
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
  rst-preview = buildVscodeExt {
    mktplcRef = {
      name = "restructuredtext";
      publisher = "lextudio";
      version = "190.1.4";
      sha256 = "sha256-u7uXzAeAFqOFcdAEOCZlTYIApRCo9VkXC0t2E6JYRfg=";
    };
    meta = { license = licenses.mit; };
  };
  rst-syntax = buildVscodeExt {
    mktplcRef = {
      name = "simple-rst";
      publisher = "trond-snekvik";
      version = "1.5.2";
      sha256 = "sha256-pV7/S8kkDIbhD2K5P2TA8E0pM4F8gsFIlc+4FIheBbc=";
    };
    meta = { license = licenses.mit; };
  };
  todo-hl = buildVscodeExt {
    mktplcRef = {
      name = "vscode-todo-highlight";
      publisher = "wayou";
      version = "1.0.5";
      sha256 = "sha256-CQVtMdt/fZcNIbH/KybJixnLqCsz5iF1U0k+GfL65Ok=";
    };
    meta = { license = licenses.mit; };
  };

  externalExts = [
    agda-mode
    haskell-spotlight
    ide-purescript
    idris-vscode
    language-purescript
    lisp-syntax
    tokyo-night
    rst-preview
    rst-syntax
    todo-hl
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
      rust-lang.rust-analyzer
    ] ++ externalExts;
    userSettings = {
      "breadcrumbs.enabled" = true;
      "editor.fontLigatures" = true;
      "editor.fontFamily" = "Hasklig, Menlo, Menlo, Monaco, 'Courier New', monospace";
      "editor.minimap.enabled" = false;
      "editor.renderWhitespace" = "boundary";
      "editor.rulers" = [ 80 ];
      "editor.tabSize" = 2;
      "editor.wordWrap" = "on";
      "editor.wordWrapColumn" = 80;
      "editor.bracketPairColorization.enabled" = true;
      "editor.guides.bracketPairs" = "active";
      "editor.unicodeHighlight.ambiguousCharacters" = false;
      "todohighlight.defaultStyle" = {
        "backgroundColor" = "none";
        "fontWeight" = "bold";
      };
      # HACK: Whitespace on keywords w/o colons is because they occasionally
      # can appear as part of another word (e.g. DEBUG), and we do not want
      # highlighting to apply in those situations.
      "todohighlight.keywords" = [
        {
          "text" = "BUG:";
          "color" = "#ff6c6b";
        }
        {
          "text" = "DEPRECATED:";
          "color" = "#83898d";
        }
        {
          "text" = "FIXME:";
          "color" = "#ff6c6b";
          "backgroundColor" = "none";
        }
        {
          "text" = "HACK:";
          "color" = "#a9a1e1";
        }
        {
          "text" = "NOTE:";
          "color" = "#5ea164";
        }
        {
          "text" = "REVIEW:";
          "color" = "#51afef";
        }
        {
          "text" = "TODO:";
          "color" = "#ecbe7b";
          # override default
          "backgroundColor" = "none";
        }
      ];
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
