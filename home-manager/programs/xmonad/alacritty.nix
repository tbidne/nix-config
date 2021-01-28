{ fontSize, pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      # globally set in picom.nix
      #background_opacity = 0.8;
      colors = {
        primary = {
          background = "#040404";
          foreground = "#c5c8c6";
        };
      };
      selection.save_to_clipboard = true;
      shell.program = "${pkgs.zsh}/bin/zsh";
      window = {
        decorations = "full";
        padding = {
          x = 5;
          y = 5;
        };
      };
    };
  };
}