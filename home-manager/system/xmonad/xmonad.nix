{ pkgs, ... }:

let
  compiler = "ghc8107";
in
{
  # For whatever reason, there is a regression that the cursor on the main
  # desktop shows an ugly X.
  xresources.properties = {
    "Xft.dpi" = 314;
    "Xft.autohint" = 0;
    "Xft.hintstyle" = "hintfull";
    "Xft.hinting" = 1;
    "Xft.antialias" = 1;
    "Xft.rgba" = "rgb";
    "Xcursor.theme" = "Vanilla-DMZ-AA";
    "Xcursor.size" = 256;
  };

  gtk = {
    enable = true;
    cursorTheme = {
      package = pkgs.vanilla-dmz;
      name = "Vanilla-DMZ-AA";
      size = 256;
    };
  };

  xsession = {
    enable = true;

    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = hp: [
        hp.dbus
        hp.monad-logger
        hp.xmonad-wallpaper
      ];
      haskellPackages = pkgs.haskell.packages.${compiler};
      config = ./config.hs;
    };
  };
}
