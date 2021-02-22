{
  users.users.tommy = {
    name = "tommy";
    description = "Tommy Bidne";
    group = "users";
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "networkmanager" ];
    uid = 1000;
    createHome = true;
    home = "/home/tommy";
    shell = "/home/tommy/.nix-profile/bin/zsh";
  };
}
