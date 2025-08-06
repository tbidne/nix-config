{ inputs }:

let
  theme = builtins.readFile "${inputs.catpuppucin.outPath}/themes/macchiato.conf";
in
{
  programs.kitty = {
    enable = true;
    font.name = "hasklig";
    settings = {
      enable_audio_bell = false;
      shell = "/run/current-system/sw/bin/bash";
      # cursor_shape = "block" and shell_integration = "no-cursor" set the
      # cursor shape to block, which is what it was previously. If we go
      # this route, also need to include "no-rc enabled" in
      # shell_integration as those are needed for normal behavior (these params
      # are default if shell_integration is unspecified).
      #
      # That said, deciding to ignore cursor_shape for now as I am somewhat
      # used to the new line/beam, and the less config the better.
      #
      # shell_integration = "no-rc enabled no-cursor";
      # cursor_shape = "block";
      tab_bar_style = "powerline";
      touch_scroll_multiplier = 1;
      wheel_scroll_multiplier = 1;
    };
    extraConfig = ''
      ${theme}
    '';
  };

  home.file.".config/kitty/quick-access-terminal.conf" = {
    text = ''
      background_opacity .90
      lines 22
    '';
  };
}
