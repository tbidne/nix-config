{ pkgs, ... }:

let
  yakuake-autostart = (pkgs.makeAutostartItem {
    name = "yakuake";
    package = pkgs.yakuake;
    srcPrefix = "org.kde.";
  });
in
{
  # Enable the Plasma 5 Desktop Environment and plasma
  # specific applications.
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # HiDPI
  environment.variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
  };
  # https://www.sven.de/dpi/
  services.xserver.dpi = 314;

  environment.systemPackages = with pkgs; [
    conky
    #plasma5.plasma-browser-integration
    yakuake
    yakuake-autostart
  ];
}
