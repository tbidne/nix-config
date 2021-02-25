{ fontSize, pkgs, ... }:

let theme = import ./dracula.nix;
in
{ 
  programs.alacritty = {
    enable = true;
    settings = {
      background_opacity = 0.5;
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
