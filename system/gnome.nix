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
  };
}
