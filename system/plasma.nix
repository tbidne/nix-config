{ inputs }:

let
  pkgs = inputs.pkgs;
in
{
  services.xserver = {
    enable = true;
    # NOTE: There is an sddm bug that sometimes rears its head on startup via
    # a blackscreen. Fix by running
    # sudo rm -rf /var/lib/sddm/.cache/sddm-greeter/qmlcache
    displayManager = {
      sddm.enable = true;
      #sddm.enableHidpi = true;
    };

    desktopManager = {
      plasma5.enable = true;
      #plasma5.useQtScaling = true;
      xterm.enable = false;
    };

    # HiDPI
    # https://www.sven.de/dpi/
    dpi = 280;
  };

  environment.systemPackages = [
    pkgs.libsForQt5.bismuth

    # for kitty dropdown
    pkgs.tdrop
  ];
}
