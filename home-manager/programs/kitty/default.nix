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
      # Got this from https://sw.kovidgoyal.net/kitty/conf/#tab-bar. Normally,
      # I have this undefined and just use the default. However, at some
      # point recently the title behavior changed so that its name was
      # permanently set to the last command that was run. When commands are
      # long, this is quite ugly. Previously, the title only used the command
      # while it was running, which was acceptable.
      #
      # Hence we now manually set it. Note that we could alternatively set
      # tab_title_max_length.
      tab_title_template = "{fmt.fg.red}{bell_symbol}{activity_symbol}{fmt.fg.tab}{tab.last_focused_progress_percent}{index}";
      touch_scroll_multiplier = 1;
      wheel_scroll_multiplier = 1;
    };
    extraConfig = ''
      # https://github.com/kovidgoyal/kitty/issues/10066
      auto_reload_config -1

      ${theme}
    '';
  };

  home.file.".config/kitty/quick-access-terminal.conf" = {
    text = ''
      background_opacity .90
      lines 25
    '';
  };
}
