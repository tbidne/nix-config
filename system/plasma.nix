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

  services.xserver.enable = false;

  # NOTE: We ran into an issue where the screenlocker was not working. That is,
  # whenever the system was suspended (e.g. 'nap', closing the lid), upon awaking
  # we would receive some black screen error like 'screen locker failed ...',
  # where the only resolution was either restart or launch a virtual terminal
  # and reload-ui.
  #
  # This did not seem related to nixpkgs (e.g. multiple hashes had the same
  # problem). My _guess_ is that this had to do w/ my screenlocker's wallpaper
  # using apod, and there was maybe a cert error (observed when digging into
  # screenlocker settings). Changing the wallpaper to a local, static image
  # seems to have 'fixed' the issue.

  services.desktopManager.plasma6 = {
    enable = true;
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  environment.systemPackages = [
    pkgs.kdePackages.oxygen
  ];

  # tdrop does not work with wayland, and there does not appear to be any
  # alternatives for KDE, at the moment. Give up for now or use yaquake.
  #
  # environment.systemPackages = [
  #   # for kitty dropdown
  #   pkgs.tdrop

  #   # Needed for tdrop, apparently
  #   pkgs.xorg.xrandr
  # ];
}
