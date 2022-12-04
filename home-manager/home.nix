{ inputs }:
{
  imports = [
    (import ./programs/default.nix { inherit inputs; })
    (import ./system/default.nix { inherit inputs; })
  ];

  home.file = {
    # Blanking these files. I'm not sure where they came from (they are not
    # part of nixos-rebuild), but they were holding outdated cache info that
    # was causing my system to use caches not reflected in
    # nix.settings.substituters.
    #
    # A better solution would be to prevent these files from being created.
    ".config/nix/netrc".text = "";
    ".config/nix/nix.conf".text = "";
  };

  home.stateVersion = "22.11";
}
