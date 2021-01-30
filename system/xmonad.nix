{ pkgs, ... }:

{
  services = {
    gnome3.gnome-keyring.enable = true;
    upower.enable = true;

    dbus = {
      enable = true;
      socketActivated = true;
      packages = [ pkgs.gnome3.dconf ];
    };

    xserver = {
      enable = true;
      layout = "us";
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
    alacritty
    betterlockscreen       # lock screen
    feh                    # setting the wallpaper
    flameshot              # screenshot
    haskellPackages.xmobar # xmobar
    networkmanagerapplet   # network manager gui
    pcmanfm                # file browser
    rofi                   # app launcher
    xorg.xwininfo          # get X window information
  ];

  environment.variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    XCURSOR_SIZE = "64";
  };
}
