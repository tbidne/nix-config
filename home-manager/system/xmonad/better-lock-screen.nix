{ pkgs, ... }:

{
  # To update, run e.g.
  # betterlockscreen -u /path/ --fx dim,blur
  services.screen-locker = {
    enable = true;
    inactiveInterval = 30;
    lockCmd = "${pkgs.betterlockscreen}/bin/betterlockscreen -l dim";
    xautolock.extraOptions = [
      "Xautolock.killer: systemctl suspend"
    ];
  };
}
