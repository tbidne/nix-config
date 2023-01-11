{ inputs }:

let
  pkgs = inputs.pkgs;
in
{
  services.xserver = {
    enable = true;
    displayManager = {
      sddm.enable = true;
      #sddm.enableHidpi = true;
    };

    desktopManager = {
      cinnamon.enable = true;
      xterm.enable = false;
    };
    displayManager.defaultSession = "cinnamon";

    # HiDPI
    # https://www.sven.de/dpi/
    dpi = 280;
  };
}
