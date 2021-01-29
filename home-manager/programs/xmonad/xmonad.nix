{ pkgs, ...}:

let
  compiler = "ghc8101";
in
{
  xresources.properties = {
    "Xft.dpi" = 314;
    "Xft.autohint" = 0;
    "Xft.hintstyle" = "hintfull";
    "Xft.hinting" = 1;
    "Xft.antialias" = 1;
    "Xft.rgba" = "rgb";
    "Xcursor.theme" = "Vanilla-DMZ-AA";
    "Xcursor.size" = 64;
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
