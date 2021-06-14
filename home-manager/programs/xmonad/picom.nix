{
  # NOTE: The opacity settings (at least) don't appear to be picked up.
  # They are correctly written to the conf files in /nix/store, but they
  # do not seem to have an effect. The culprit may be XMonad (and ewmh?),
  # so for now opacity is handled individually, e.g. kitty has its own
  # settings, and XMonad handles the general "inactive = faded" setting.
  #
  # I discovered this when trying to add blurring here, which also does
  # not work, sadly. Keeping this here for now, but we may have to switch
  # WMs to get blurring/rounded corners.
  services.picom = {
    enable = true;
    activeOpacity = "1.0";
    inactiveOpacity = "1.0";
    backend = "glx";
    fade = true;
    fadeDelta = 5;
    #opacityRule = [ "100:name *= 'i3lock'" ];
    shadow = true;
    shadowOpacity = "0.75";
  };
}
