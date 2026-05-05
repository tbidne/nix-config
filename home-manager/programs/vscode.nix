{ inputs }:

let
  buildVscodeExt = inputs.pkgs.vscode-utils.buildVscodeMarketplaceExtension;
  licenses = inputs.pkgs.lib.licenses;

  agda-mode = buildVscodeExt {
    mktplcRef = {
      name = "agda-mode";
      publisher = "banacorn";
      version = "0.9.1";
      sha256 = "sha256-gtUZfmsoWbRqp29BzPJrWMb3yNHS1wftH/ZMWLIzSeg=";
    };
    meta = {
      license = licenses.mit;
    };
  };
  haskell-debugger-extension = buildVscodeExt {
    mktplcRef = {
      name = "haskell-debugger-extension";
      publisher = "Well-Typed";
      version = "0.13.1";
      sha256 = "sha256-AN5Vd99cYsdMJedXkXekau8tcaAMppzo7JLtdimItzM=";
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
      version = "0.26.6";
      sha256 = "sha256-zYLAcPgvfouMQj3NJlNJA0DNeayKxQhOYNloRN2YuU8=";
    };
    meta = {
      license = licenses.mit;
    };
  };
  idris-vscode = buildVscodeExt {
    mktplcRef = {
      publisher = "meraymond";
      name = "idris-vscode";
      version = "0.0.15";
      sha256 = inputs.pkgs.lib.fakeHash;
    };
    meta = {
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
      version = "0.2.10";
      sha256 = "sha256-JBKswfQuxaZe6stgwFsyxS9hlil6OXKzFGV11za6JbQ=";
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
      version = "2.6.6";
      sha256 = "sha256-Xs6D3P8DQAHIBcJQ/NVUy5WxY0QMhlKgqRQd+md0mr8=";
    };
    meta = {
      license = licenses.mit;
    };
  };
  rst-preview = buildVscodeExt {
    mktplcRef = {
      name = "restructuredtext";
      publisher = "lextudio";
      version = "190.1.11";
      sha256 = "sha256-y5KReXeqnxxR0W/ydIRL5KBBPtA+WFre+tJ9hC1suKI=";
    };
    meta = {
      license = licenses.mit;
    };
  };
  rst-syntax = buildVscodeExt {
    mktplcRef = {
      name = "simple-rst";
      publisher = "trond-snekvik";
      version = "1.5.4";
      sha256 = "sha256-W3LydBsc7rEHIcjE/0jESFS87uc1DfjuZt6lZhMiQcs=";
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
  tokyo-night = buildVscodeExt {
    mktplcRef = {
      name = "tokyo-night";
      publisher = "enkia";
      version = "1.1.2";
      sha256 = "sha256-oW0bkLKimpcjzxTb/yjShagjyVTUFEg198oPbY5J2hM=";
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
    # FIXME: Something wrong with idris. Maybe because the publisher changed
    # there name and it's a warning?
    #idris-vscode
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
  programs.vscodium = {
    enable = true;

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
          dracula-theme.theme-dracula
          eamodio.gitlens
          editorconfig.editorconfig
          haskell.haskell
          #james-yu.latex-workshop # FIXME: Extension too old for current vscode
          jnoortheen.nix-ide
          justusadam.language-haskell
          mechatroner.rainbow-csv
          ms-python.python
          ms-python.vscode-pylance
          octref.vetur
          streetsidesoftware.code-spell-checker
          tamasfe.even-better-toml
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
        #
        # Tells vscode to use new multi-repl mode. (cf. "singleComponent").
        #
        # To verify, after loading a haskell project, check the logs for:
        #
        #     Load cabal cradle using all files (multi-components)
        #
        # As opposed to:
        #
        #     Load cabal cradle using single file
        #
        # Note that we may also want cabal.project to have 'multi-repl: True'.
        #
        # See https://github.com/haskell/haskell-language-server/issues/3694
        "haskell.sessionLoading" = "multipleComponents";
      };
    };
  };
}
