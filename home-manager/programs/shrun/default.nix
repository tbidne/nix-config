let
  shrun = builtins.readFile ./config.toml;
in
{
  home.file.".config/shrun/config.toml".text = "${shrun}";
}
