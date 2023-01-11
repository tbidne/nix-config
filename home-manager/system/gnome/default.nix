{ inputs }:

{
  # Use `dconf watch /` to track stateful changes you are doing, then set them here.
  #
  # https://hoverbear.org/blog/declarative-gnome-configuration-in-nixos/
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };

    "org/gnome/mutter/dynamic-workspaces" = {
      dynamic-workspaces = false;
    };

    "org/gnome/desktop/wm/preferences" = {
      num-workspaces = 4;
    };

    "org/gnome/shell/app-switcher" = {
      current-workspace-only = true;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      two-finger-scrolling-enabled = true;
      tap-to-click = true;
    };

    "org/gnome/desktop/peripherals/mouse" = {
      natural-scroll = true;
    };
  };
}
