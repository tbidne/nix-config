{ pkgs, ... }:

let
  compiler = "ghc921";
  xmonad-packages = pkgs.haskell.packages.${compiler}.override (old: {
    overrides = pkgs.lib.composeExtensions (old.overrides or (_: _: { }))
      (final: prev: {
        dbus = prev.dbus_1_2_23;
        xmonad = prev.xmonad_0_17_0;
        xmonad-contrib = prev.xmonad-contrib_0_17_0;
        xmonad-extras = prev.xmonad-extras_0_17_0;
        xmonad-wallpaper = pkgs.haskell.lib.doJailbreak prev.xmonad-wallpaper;
      });
  });
in
{
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
          haskellPackages = xmonad-packages;
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
