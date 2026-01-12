{ inputs }:

let
  buildVscodeExt = inputs.pkgs.vscode-utils.buildVscodeMarketplaceExtension;
  licenses = inputs.pkgs.lib.licenses;

  agda-mode = buildVscodeExt {
    mktplcRef = {
      name = "agda-mode";
      publisher = "banacorn";
      version = "0.4.7";
      sha256 = "sha256-gNa3n16lP3ooBRvGaugTua4IXcIzpMk7jBYMJDQsY00=";
    };
    meta = {
      license = licenses.mit;
    };
  };
  haskell-debugger-extension = buildVscodeExt {
    mktplcRef = {
      name = "haskell-debugger-extension";
      publisher = "Well-Typed";
      version = "0.11.0";
      sha256 = "sha256-NQw8FRIjS54Cn+0vaYJ3DFzzqVYRGTMKRJy2Npp8wfo=";
    };
    meta = {
      license = licenses.mit;
    };
  };
  haskell-spotlight = buildVscodeExt {
    mktplcRef = {
      name = "haskell-spotlight";
      publisher = "visortelle";
      version = "0.0.3";
      sha256 = "sha256-pHrGjAwb5gWxzCtsUMU6+zdQTI8aMxiwtQi4fc9JH9g=";
    };
    meta = {
      license = licenses.mit;
    };
  };
  ide-purescript = buildVscodeExt {
    mktplcRef = {
      name = "ide-purescript";
      publisher = "nwolverson";
      version = "0.25.12";
      sha256 = "1f9064w18wwp3iy8ciajad8vlshnzyhnqy8h516k0j5bflz781mn";
    };
    meta = {
      license = licenses.mit;
    };
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
  insert-unicode = buildVscodeExt {
    mktplcRef = {
      name = "insert-unicode";
      publisher = "brunnerh";
      version = "0.15.1";
      sha256 = "sha256-RHsq7JmlC+4zGSbDdovCZpjpSW+DvcmYnuz9f6F/N4g=";
    };
    meta = {
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
    meta = {
      license = licenses.mit;
    };
  };
  lisp-syntax = buildVscodeExt {
    mktplcRef = {
      name = "Lisp-Syntax";
      publisher = "slbtty";
      version = "0.2.1";
      sha256 = "sha256-Jos0MJBuFlbfyAK/w51+rblslNq+pHN8gl1T0/UcP0Q=";
    };
    meta = {
      license = licenses.mit;
    };
  };
  mermaid-chart = buildVscodeExt {
    mktplcRef = {
      name = "vscode-mermaid-chart";
      publisher = "mermaidchart";
      version = "2.3.0";
      sha256 = "sha256-XwrO2gaSGjVdHIf3w+pW1JkHEBQf4r/l2nrnKFsJnpc=";
    };
    meta = {
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
    meta = {
      license = licenses.mit;
    };
  };
  rst-preview = buildVscodeExt {
    mktplcRef = {
      name = "restructuredtext";
      publisher = "lextudio";
      version = "190.1.4";
      sha256 = "sha256-u7uXzAeAFqOFcdAEOCZlTYIApRCo9VkXC0t2E6JYRfg=";
    };
    meta = {
      license = licenses.mit;
    };
  };
  rst-syntax = buildVscodeExt {
    mktplcRef = {
      name = "simple-rst";
      publisher = "trond-snekvik";
      version = "1.5.2";
      sha256 = "sha256-pV7/S8kkDIbhD2K5P2TA8E0pM4F8gsFIlc+4FIheBbc=";
    };
    meta = {
      license = licenses.mit;
    };
  };
  todo-hl = buildVscodeExt {
    mktplcRef = {
      name = "vscode-todo-highlight";
      publisher = "wayou";
      version = "1.0.5";
      sha256 = "sha256-CQVtMdt/fZcNIbH/KybJixnLqCsz5iF1U0k+GfL65Ok=";
    };
    meta = {
      license = licenses.mit;
    };
  };
  vscode-auto-scroll = buildVscodeExt {
    mktplcRef = {
      name = "vscode-auto-scroll";
      publisher = "pejmannikram";
      version = "1.2.0";
      sha256 = "sha256-n9XVvXxrYbJ02fhBcWnPFhl50t2g/qeT1rRqsWHwrmE=";
    };
    meta = {
      license = licenses.mit;
    };
  };

  externalExts = [
    agda-mode
    haskell-debugger-extension
    haskell-spotlight
    ide-purescript
    idris-vscode
    insert-unicode
    language-purescript
    lisp-syntax
    mermaid-chart
    tokyo-night
    rst-preview
    rst-syntax
    todo-hl
    vscode-auto-scroll
  ];
in
{
  # BUG: For some reason, cached gpu settings seems to break the vscode on load
  # sometimes. A workaround is to delete ~/.config/VSCodium/GPUCache/.
  # If this becomes a frequent problem, perhaps wrap the exe in logic to
  # delete this directory on startup.
  programs.vscode = {
    enable = true;
    # Nb. With this, extensions get put in ~/.vscode-oss/. Otherwise
    # it is ~/.vscode/.
    package = inputs.pkgs.vscodium;

    profiles.default = {

      # BUG: Encountered a strange bug where none of my extensions loaded.
      # First, to test changes, we probably need to make a change to the
      # extension set here i.e. enable/disable some.
      #
      # To be honest, I have no idea what caused it. I deleted .vscode,
      # .vscode-oss, and ~/.VSCodium. I also toggled the nix setting
      #
      #   mutableExtensionsDir = true;
      #
      # (default true, I think). In the end, what worked __appears__ to be the
      # combination of deleting those directories and rebuilding, ensuring
      # we make some changes to the extension list so that a rebuild actually
      # happens.

      # If this worked then we should _at least_ have extensions in
      # .vscode-oss/extensions/extensions.json
      extensions =
        with inputs.pkgs.vscode-extensions;
        [
          arcticicestudio.nord-visual-studio-code
          bbenoist.nix
          bungcip.better-toml
          dracula-theme.theme-dracula
          eamodio.gitlens
          editorconfig.editorconfig
          haskell.haskell
          james-yu.latex-workshop
          jnoortheen.nix-ide
          justusadam.language-haskell
          mechatroner.rainbow-csv
          #ms-python.python # FIXME: currently broken
          ms-python.vscode-pylance
          octref.vetur
          rust-lang.rust-analyzer
        ]
        ++ externalExts;

      globalSnippets = {
        texMathBbC = {
          body = [ "ℂ" ];
          description = "Insert LaTeX \\mathbb{C}, U+2112";
          prefix = [ "\\C" ];
        };
        texMathBbN = {
          body = [ "ℕ" ];
          description = "Insert LaTeX \\mathbb{N}, U+2115";
          prefix = [ "\\N" ];
        };
        texMathBbP = {
          body = [ "ℙ" ];
          description = "Insert LaTeX \\mathbb{P} U+2119";
          prefix = [ "\\P" ];
        };
        texMathBbQ = {
          body = [ "ℚ" ];
          description = "Insert LaTeX \\mathbb{Q}, U+211A";
          prefix = [ "\\Q" ];
        };
        texMathBbR = {
          body = [ "ℝ" ];
          description = "Insert LaTeX \\mathbb{R}, U+211D";
          prefix = [ "\\R" ];
        };
        texMathBbZ = {
          body = [ "ℤ" ];
          description = "Insert LaTeX \\mathbb{Z}, U+2114";
          prefix = [ "\\Z" ];
        };
      };

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

        # so e.g. format json files does not strip final newline.
        "files.insertFinalNewline" = true;

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
        # This options seems deprecated
        #"workbench.activityBar.location" = "hidden";
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
        # This setting has started showing inline record fields, which
        # makes the code very difficult to read. Consider checking later
        # to see if this is 'fixed' upstream.
        "haskell.plugin.explicit-fields.inlayHintsOn" = false;
      };
    };
  };
}
