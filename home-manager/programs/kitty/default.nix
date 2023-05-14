{ inputs }:

let
  theme = builtins.readFile "${inputs.catpuppucin.outPath}/themes/macchiato.conf";
in
{
  programs.kitty = {
    enable = true;
    font.name = "hasklig";
    settings = {
      cursor_shape = "block";
      enable_audio_bell = false;
      shell = "/run/current-system/sw/bin/bash";
      # needed so that we use the cursor_shape block. otherwise it is overridden
      # somehow.
      shell_integration = "no-cursor";
      tab_bar_style = "powerline";
      touch_scroll_multiplier = 1;
      wheel_scroll_multiplier = 1;
    };
    extraConfig = ''
      ${theme}
    '';
  };
}
