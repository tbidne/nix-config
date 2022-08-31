{ inputs, ... }:

{
  imports = [
    ./openweathermap.nix
  ];

  home.file.".config/polybar/config.ini" = {
    source = ./config.ini;
  };
}
