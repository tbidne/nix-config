{
  imports = [
    ./config.nix

    # I would like to include this script, but it relies on an api key
    # I don't want to put in version control. I don't currently know how
    # to give nix access to an env var that it also sets, so for now
    # the script in this nix file is hardcoded in my home directory
    #./openweathermap.nix
  ];
}
