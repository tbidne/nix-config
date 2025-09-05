{
  # https://nixos.wiki/wiki/IOS
  #
  # I just mount via ifuse i.e.
  #
  #   ifuse ~/iphone
  #
  # This mounts it in the filesystem, and iPhone also shows up in KDE Dolphin.
  # I do not currently use idevicepair.
  #
  # Note that I had to kill the running usbmuxd instance the first time I
  # enabled this device. Also note that there are some reports of errors that
  # can be fixed by overriding the package:
  #
  #   services.usbmuxd = {
  #     enable = true;
  #     package = pkgs.usbmuxd2;
  #   };
  #
  # Strictly speaking, these _may_ not be necessary, since KDE Dolphin
  # seems fine without it. But we enable them in case they are useful in
  # the future.
  services.usbmuxd.enable = true;
}
