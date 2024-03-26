{
  users.users.tommy = {
    name = "tommy";
    description = "Tommy Bidne";
    group = "users";
    isNormalUser = true;
    extraGroups = [
      "audio"
      "docker"
      "networkmanager"
      "podman"
      "wheel"
    ];
    uid = 1000;
    createHome = true;
    home = "/home/tommy";
    shell = "/run/current-system/sw/bin/bash";
  };
}
