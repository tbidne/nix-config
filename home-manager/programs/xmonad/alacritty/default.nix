{ fontSize, pkgs, ... }:

let theme = import ./dracula.nix;
in
{
  programs.alacritty = {
    enable = true;
    settings = {
      background_opacity = 0.5;
      colors.primary = theme.primary;
      colors.normal = theme.normal;
      # For some reason if I include dracula bright then
      # it kills zsh auto completion...
      #colors.bright = theme.bright;
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
