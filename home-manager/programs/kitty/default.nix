{ fontSize, pkgs, ... }:

let theme = import ./dracula.nix;
in
{
  programs.kitty = {
    enable = true;
    font.name = "hasklig";
    settings = {
      shell = "/run/current-system/sw/bin/bash";
      extraConfig = ''
        ${theme.conf}
        wheel_scroll_multiplier 1.0
        touch_scroll_multiplier 1.0
        enable_audio_bell no
      '';
    };
  };
}
