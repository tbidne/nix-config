{ inputs }:

{
  services = {
    gnome.gnome-keyring.enable = true;
    upower.enable = true;

    dbus = {
      enable = true;
      packages = [ inputs.pkgs.dconf ];
    };

    xserver = {
      enable = true;
      layout = "us";

      windowManager = {
        xmonad = {
          enable = true;
          enableContribAndExtras = true;
          extraPackages = inputs.xmonad-extra;
          haskellPackages = inputs.xmonad-ghc;
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

  environment.systemPackages = with inputs.pkgs; [
    betterlockscreen # lock screen
    brightnessctl # control backlight
    deadd-notification-center #notif server
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
