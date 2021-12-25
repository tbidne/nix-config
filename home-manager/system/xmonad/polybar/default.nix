{ ... }:

let
  config = builtins.readFile ./config.ini;
in
{
  imports = [
    ./openweathermap.nix
  ];

  home.file = {
    ".config/polybar/config".text = ''
      ${config}
    '';
  };
}
