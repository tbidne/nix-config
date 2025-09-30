{ inputs }:

{
  # needed for kitty
  xresources.properties = {
    "Xft.dpi" = 280;
  };

  # To update:
  #
  # 1. nix run github:pjones/plasma-manager > old.nix
  # 2. Change whatever settings we want in system settings
  # 3. nix run github:pjones/plasma-manager > new.nix
  # 4. diff old.nix new.nix
  # Between the diff, github:pjones/plasma-manager, and files themselves
  # (e.g. kglobalshortcutsrc), modify the below settings.
  #
  # Naturally, we need to reload the ui to see any changes.
  programs.plasma = {
    enable = true;

    # Some settings that do not appear to be here:
    #
    #   - With the 2.5 scaling, I have the bottom panel set to size 40.
    #   - Settings -> Display configuration: legacy apps apply scaling themselves.

    shortcuts = {
      kwin = {
        ShowDesktopGrid = [
          "Meta+Ctrl+Space"
          "Ctrl+F8"
        ];
        "Window Close" = [
          "Alt+F4"
          "Meta+Backspace"
        ];
        "Window to Desktop 1" = "Alt+1";
        "Window to Desktop 2" = "Alt+2";
        "Window to Desktop 3" = "Alt+3";
        "Window to Desktop 4" = "Alt+4";
        "Window to Desktop 5" = "Alt+5";
        "Window to Desktop 6" = "Alt+6";
        "Window to Desktop 7" = "Alt+7";
        "Window to Desktop 8" = "Alt+8";
      };
      # This allows us to use meta to open the start menu
      "plasmashell"."activate widget 23" = "Alt+F1,none,Activate Application Launcher Widget";

      # Launch kitty
      "services/net.local.kitty.desktop"."_launch" = "Meta+Return";
      "services/net.local.kitten.desktop"."_launch" = "Alt+=";
    };

    configFile = {
      "kwinrc"."Desktops"."Id_1" = "3868ba12-ce3b-4f2a-838a-c79089819633";
      "kwinrc"."Desktops"."Id_2" = "419c8acf-d73b-48a8-a244-a748545c7674";
      "kwinrc"."Desktops"."Id_3" = "51eb43ac-377f-493f-900e-185583f81ad7";
      "kwinrc"."Desktops"."Id_4" = "6f5f55b7-3aae-4d92-8bb0-b5c502e44929";
      "kwinrc"."Desktops"."Name_1" = 1;
      "kwinrc"."Desktops"."Name_2" = 2;
      "kwinrc"."Desktops"."Name_3" = 3;
      "kwinrc"."Desktops"."Name_4" = 4;
      "kwinrc"."Desktops"."Number" = 4;
      "kwinrc"."Desktops"."Rows" = 2;

      # mouse / touchpad
      "kwinrc"."Windows"."FocusPolicy" = "FocusFollowsMouse";
      "kwinrc"."Windows"."DelayFocusInterval" = 100;
      "kcminputrc"."Libinput/1133/16528/Logitech MX Anywhere 3"."NaturalScroll" = true;
      "kcminputrc"."Libinput/1739/52619/SYNA8006:00 06CB:CD8B Touchpad"."NaturalScroll" = true;
      "kcminputrc"."Libinput/1739/52619/SYNA8006:00 06CB:CD8B Touchpad"."TapToClick" = true;

      "kwinrc"."Effect-overview"."GridBorderActivate" = 1;

      # KDE redshift equivalent. Wayland alternative is:
      #
      #  services.wlsunset = {
      #    enable = true;
      #    latitude = ...;
      #    longitude = ...;
      #  };
      "kwinrc"."NightColor"."Active" = true;
      # Coordinates rom wikipedia: Wellington, NZ
      "kwinrc"."NightColor"."LatitudeFixed" = "-41.2889";
      "kwinrc"."NightColor"."LongitudeFixed" = "174.7772";
      "kwinrc"."NightColor"."Mode" = "Location";

      # scaling
      "dolphinrc"."IconsMode"."PreviewSize" = 112;
      "kwinrc"."Xwayland"."Scale" = 2.5;

      # other
      "plasma-localerc"."Formats"."LC_MEASUREMENT" = "C";
      "plasmanotifyrc"."Notifications"."PopupPosition" = "TopRight";
    };
  };
}
