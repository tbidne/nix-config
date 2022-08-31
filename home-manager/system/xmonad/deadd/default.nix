{ inputs, ... }:

let
  conf = builtins.readFile ./deadd.conf;
  css = builtins.readFile ./deadd.css;
in
{
  home.file.".config/deadd/deadd.conf" = {
    source = ./deadd.conf;
  };
  home.file.".config/deadd/deadd.css" = {
    source = ./deadd.css;
  };
}
