# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs }:

{
  nix = {
    package = inputs.pkgs.nixFlakes;
    # NOTE: This is pretty gross, but most of this prompt is stolen from the
    # functions.sh file. The main differenec is the end, where we add the emoji
    # for a snowflake.
    #
    # Now, this sometimes interacts badly with the test that comes after, so
    # we have found the following hack, which seems to allow the prompt to
    # terminate in a single space.
    extraOptions = ''
      experimental-features = nix-command flakes
      bash-prompt = \[\033[01;34m\]\w \[\033[31m\]`git branch 2> /dev/null | grep -e ^* | sed -E  s/^\\\\\*\ \(.+\)$/\(\\\\\1\)\ /`\[\033[35m\]\n❄️\[\033[00m\][$SHLVL] \0
    '';

    # so I can configure binary caches without sudo
    settings.trusted-users = [
      "root"
      "tommy"
    ];
  };

  imports =
    [
      # system
      ./hardware-configuration.nix

      (import ./system/default.nix { inherit inputs; })

      # general config
      (import ./config/default.nix { inherit inputs; })
    ];

  nixpkgs.config.allowUnfree = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
