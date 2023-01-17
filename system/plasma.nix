{ inputs }:

let
  pkgs = inputs.pkgs;
in
{
  # NOTE: Plasma occasionally freezes. Sometimes the panel works (in which
  # case we can launch a new kitty and reload the ui), and sometimes it does
  # not, forcing a hard restart.
  #
  # https://github.com/NixOS/nixpkgs/issues/60312 suggests deleting caches
  # i.e. ~/.cache/kwin. Try deleting that and ~/.cache/kwin_rules_dialog/.
  #
  # UPDATE: https://github.com/NixOS/nixpkgs/issues/206868 blames mesa,
  # and is allegedly fixed by mesa 22.3 (currently on 22.2, see
  # ls /nix/store | grep mesa).

  services.xserver = {
    enable = true;
    # NOTE: There is an sddm bug that sometimes rears its head on startup via
    # a blackscreen. Fix by running
    # sudo rm -rf /var/lib/sddm/.cache/sddm-greeter/qmlcache
    displayManager = {
      sddm.enable = true;
      sddm.enableHidpi = true;

      # switch to "plasmawayland" once the bugs are fixed...
      defaultSession = "plasma";
    };

    desktopManager = {
      plasma5.enable = true;
      #plasma5.useQtScaling = true;
      xterm.enable = false;
    };

    # HiDPI
    # https://www.sven.de/dpi/
    dpi = 280;
  };

  environment.systemPackages = [
    pkgs.libsForQt5.bismuth

    # for kitty dropdown
    pkgs.tdrop
  ];
}
