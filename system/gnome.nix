{ inputs }:

let
  pkgs = inputs.pkgs;
in
{
  services.xserver = {
    enable = true;

    displayManager.gdm = {
      enable = true;
      wayland = true;
    };

    desktopManager = {
      gnome.enable = true;
      xterm.enable = false;
    };

    # HiDPI
    # https://www.sven.de/dpi/
    #dpi = 280;
    #dpi = 314;
  };

  #environment.variables = {
  #  GDK_SCALE = "2";
  #  GDK_DPI_SCALE = "0.5";
  #};
}
