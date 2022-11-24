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
  programs.plasma = {
    enable = true;

    shortcuts = {
      "kitty.desktop"."_launch" = "Meta+Shift+Return";
      kwin = {
        ShowDesktopGrid = ["Meta+Ctrl+Space" "Ctrl+F8"];
        "Window Close" = ["Alt+F4" "Meta+Backspace"];
      };
      "plasmashell"."activate widget 23" = "Alt+F1,none,Activate Application Launcher Widget";
    };
    files = {
      "kwinrc"."Desktops"."Id_1" = "3868ba12-ce3b-4f2a-838a-c79089819633";
      "kwinrc"."Desktops"."Id_2" = "419c8acf-d73b-48a8-a244-a748545c7674";
      "kwinrc"."Desktops"."Id_3" = "51eb43ac-377f-493f-900e-185583f81ad7";
      "kwinrc"."Desktops"."Id_4" = "6f5f55b7-3aae-4d92-8bb0-b5c502e44929";
      "kwinrc"."Desktops"."Id_5" = "075466d5-455a-41c2-8788-caf969a83402";
      "kwinrc"."Desktops"."Id_6" = "75db39a8-de35-4067-98a0-89fc657ff30a";
      "kwinrc"."Desktops"."Id_7" = "96ef2df2-6a23-4a88-9d2f-a350c3c80d95";
      "kwinrc"."Desktops"."Id_8" = "58609185-562e-444a-b9eb-7687ee11b923";
      "kwinrc"."Desktops"."Name_1" = 1;
      "kwinrc"."Desktops"."Name_2" = 2;
      "kwinrc"."Desktops"."Name_3" = 3;
      "kwinrc"."Desktops"."Name_4" = 4;
      "kwinrc"."Desktops"."Name_5" = 5;
      "kwinrc"."Desktops"."Name_6" = 6;
      "kwinrc"."Desktops"."Name_7" = 7;
      "kwinrc"."Desktops"."Name_8" = 8;
      "kwinrc"."Desktops"."Number" = 8;
      "kwinrc"."Desktops"."Rows" = 2;
      "kcminputrc"."Mouse"."XLbInptNaturalScroll" = true;
      "kcminputrc"."Mouse"."cursorSize" = 48;
      "kwinrc"."Windows"."FocusPolicy" = "FocusFollowsMouse";
    };
  };
}
