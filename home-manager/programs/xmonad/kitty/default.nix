{ fontSize, pkgs, ... }:

let theme = import ./dracula.nix;
in
{ 
  programs.kitty = {
    enable = true;
    font.name = "hasklig";
    settings = {
      background_opacity = "0.50";
      shell = "${pkgs.zsh}/bin/zsh";
      extraConfig = ''
        ${theme.conf}
      '';
    };
  };
}
