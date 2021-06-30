{ pkgs, static-assets, ... }:

{
  services.dunst = {
    enable = true;

    settings = {
      global = {
        alignment = "left";
        corner_radius = 20;
        ellipsize = "end";
        format = "%a\\n%s\\n%b";
        frame_color = "#eceff1";
        frame_width = 5;
        geometry = "1000x5-10+110";
        horizontal_padding = 8;
        icon_position = "left";
        idle_threshold = 120;
        ignore_newline = true;
        indicate_hidden = "yes";
        markup = "full";
        min_icon_size = 0;
        max_icon_size = 128;
        mouse_left_click = "close_current";
        mouse_middle_click = "do_action, close_current";
        mouse_right_click = "close_all";
        notification_height = 5;
        separator_color = "frame";
        separator_height = 5;
        show_indicators = false;
        shrink = "no";
        transparency = 10;
        word_wrap = "no";
        vertical_alignment = "center";
      };

      element = {
        appname = "Element";
        desktop_entry = "Electron";
        new_icon = "${static-assets}/share/icons/element.svg";
      };

      mattermost = {
        appname = "mattermost";
        new_icon = "${static-assets}/share/icons/mattermost.svg";
      };

      slack = {
        desktop_entry = "Slack";
        new_icon = "${static-assets}/share/icons/slack.svg";
      };

      urgency_normal = {
        background = "#363749";
        foreground = "#eceff1";
        timeout = 10;
      };
    };
  };
}
