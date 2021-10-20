let
  conf = builtins.readFile ./deadd.conf;
  css = builtins.readFile ./deadd.css;
in
{
  home.file = {
    ".config/deadd/deadd.conf".text = ''
      ${conf}
    '';

    ".config/deadd/deadd.css".text = ''
      ${css}
    '';
  };
}
