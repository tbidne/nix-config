{ inputs }:

{
  # Use `dconf watch /` to track stateful changes you are doing, then set them here.
  #
  # https://hoverbear.org/blog/declarative-gnome-configuration-in-nixos/
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      locate-pointer = true;
    };

    "org/gnome/desktop/peripherals/mouse" = {
      natural-scroll = true;
      speed = -0.7318007662835249;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      two-finger-scrolling-enabled = true;
      tap-to-click = true;
    };

    "org/gnome/desktop/screensaver" = {
      picture-uri = "file:///home/tommy/.local/share/backgrounds/2023-12-03-08-54-19-wallhaven-wy18ep.jpg";
    };

    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super>BackSpace" ];
    };

    "org/gnome/mutter" = {
      dynamic-workspaces = true;
      edge-tiling = true;
    };

    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>Return";
      command = "kitty";
      name = "Launch Kitty";
    };

    "org/gnome/shell/app-switcher" = {
      current-workspace-only = true;
    };
  };
}
