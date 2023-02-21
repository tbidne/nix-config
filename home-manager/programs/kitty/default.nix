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
      extraConfig = ''
        ${theme}
        wheel_scroll_multiplier 1.0
        touch_scroll_multiplier 1.0
        enable_audio_bell no
        tab_bar_style powerline
      '';
    };
  };
}
