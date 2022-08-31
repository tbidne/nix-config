{ inputs }:

{
  home.file.".config/shrun/config.toml" = {
    source = ./config.toml;
  };
}
