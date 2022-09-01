{ inputs }:

{
  imports = [
    ./better-lock-screen.nix
    ./deadd/default.nix
    ./picom.nix
    ./polybar/default.nix
    ./rofi/default.nix
  ];

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
  };

  gtk = {
    enable = true;
    cursorTheme = {
      package = inputs.pkgs.vanilla-dmz;
      name = "Vanilla-DMZ-AA";
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = inputs.pkgs.papirus-icon-theme;
    };
    theme = {
      name = "Dracula";
      package = inputs.pkgs.dracula-theme;
    };
  };
}
