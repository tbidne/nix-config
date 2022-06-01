{ inputs }:

{
  services = {
    gnome.gnome-keyring.enable = true;
    upower.enable = true;

    # Note: when upgrading to 22.05, I received an error restarting
    # NetworkManager. journalctl | grep NetworkManager | grep error showed:
    #
    # Jun 01 13:13:20 nixos NetworkManager[782418]: <error> [1654046000.9090]
    #   bus-manager: fatal failure to acquire D-Bus service
    #   "org.freedesktop.NetworkManager: GDBus.
    #   Error:org.freedesktop.DBus.Error.AccessDenied: Connection ":1.6952"
    #   is not allowed to own the service "org.freedesktop.NetworkManager"
    #   due to security policies in the configuration file
    #
    # This led to https://github.com/NixOS/nixpkgs/issues/4546, which seemed
    # like it might fix my use-case, but it was removed in
    # 1c39a47ac87959b2589ef797e519af96d73c27d6.
    #
    # Whatever the exact causes/solutions, restarting my system and _then_
    # running nixos-rebuild worked.
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
