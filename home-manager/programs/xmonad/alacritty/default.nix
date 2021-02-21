{ fontSize, pkgs, ... }:

let theme = import ./nord.nix;
in
{ 
  programs.alacritty = {
    enable = true;
    settings = {
      # globally set in picom.nix
      background_opacity = 0.8;
      colors = theme;
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
