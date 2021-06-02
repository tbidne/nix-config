{ pkgs, ... }:

{
  services = {
    gnome.gnome-keyring.enable = true;
    upower.enable = true;

    dbus = {
      enable = true;
      packages = [ pkgs.gnome3.dconf ];
    };

    xserver = {
      enable = true;
      layout = "us";

      # As of 2021 05 02, this is only helpful for making the login screen
      # larger. It doesn't appear necessary for anything else.
      dpi = 314;

      windowManager = {
        xmonad.enable = true;
        xmonad.enableContribAndExtras = true;
        xmonad.extraPackages = hpkgs: [
          hpkgs.X11
          hpkgs.xmonad
          hpkgs.xmonad-contrib
          hpkgs.xmonad-extras
        ];
      };

      displayManager = {
        defaultSession = "none+xmonad";
        lightdm = {
          enable = true;
          greeters = {
            gtk = {
              enable = true;
              cursorTheme = {
                package = pkgs.gnome3.defaultIconTheme;
                name = "Adawaita-dark";
                size = 64;
              };
            };
          };
        };
      };
      desktopManager.xterm.enable = false;
    };
  };

  systemd.services.upower.enable = true;

  environment.systemPackages = with pkgs; [
    betterlockscreen       # lock screen
    brightnessctl          # control backlight
    feh                    # setting the wallpaper
    flameshot              # screenshot
    jq                     # openweathermap
    neofetch               # display system info
    networkmanagerapplet   # network manager gui
    pcmanfm                # file browser
    polybar                # status bar
    rofi                   # app launcher
    xorg.xwininfo          # get X window information
  ];
}
