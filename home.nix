{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

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
