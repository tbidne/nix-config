{ pkgs, ... }:

let
  compiler = "ghc8107";
in {
  services = {
    gnome.gnome-keyring.enable = true;
    upower.enable = true;

    dbus = {
      enable = true;
      packages = [ pkgs.dconf ];
    };

    xserver = {
      enable = true;
      layout = "us";

      # This is being set in home-manager/system/xmonad/xmonad.nix, and
      # currently it does not appear to do anything else. Leaving this
      # as a comment in case we want it in the future.
      #dpi = 314;

      windowManager = {
        xmonad = {
          enable = true;
          enableContribAndExtras = true;
          extraPackages = ps: [
            ps.dbus
            ps.monad-logger
            ps.X11
            ps.xmonad
            ps.xmonad-contrib
            ps.xmonad-extras
            ps.xmonad-wallpaper
          ];
          haskellPackages = pkgs.haskell.packages.${compiler};
          config = ./config.hs;
        };
      };

      displayManager = {
        defaultSession = "none+xmonad";
        lightdm = {
          enable = true;
          greeters = {
            mini = {
              enable = true;
              user = "tommy";
              extraConfig = ''
                [greeter]
                invalid-password-text = you. shall not. pass.
                password-alignment = center
                show-password-label = false
                [greeter-theme]
                background-image = #000000;
                border-color = #000000
                font-size = 24
                password-background-color = #000000
                window-color = #000000
              '';
            };
          };
        };
      };
      desktopManager.xterm.enable = false;
    };
  };

  programs.dconf = {
    enable = true;
  };

  systemd.services.upower.enable = true;

  environment.systemPackages = with pkgs; [
    betterlockscreen # lock screen
    brightnessctl # control backlight
    feh # setting the wallpaper
    flameshot # screenshot
    jq # openweathermap
    neofetch # display system info
    networkmanagerapplet # network manager gui
    pcmanfm # file browser
    polybar # status bar
    rofi # app launcher
    xorg.xwininfo # get X window information
  ];
}
