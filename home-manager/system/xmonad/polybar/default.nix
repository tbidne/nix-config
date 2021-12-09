{ ... }:

let
  config = builtins.readFile ./config.ini;
in
{
  #imports = [
  #  (import ./openweathermap.nix { inherit secrets; })
  #];

  home.file = {
    ".config/polybar/config".text = ''
      ${config}
    '';
  };
}
