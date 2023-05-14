{ inputs }:

let
  theme = builtins.readFile "${inputs.catpuppucin.outPath}/themes/macchiato.conf";
in
{
  programs.kitty = {
    enable = true;
    font.name = "hasklig";
    settings = {
      shell = "/run/current-system/sw/bin/bash";
      wheel_scroll_multiplier = 1;
      touch_scroll_multiplier = 1;
      enable_audio_bell = false;
      tab_bar_style = "powerline";
    };
    extraConfig = ''
      ${theme}
    '';
  };
}
