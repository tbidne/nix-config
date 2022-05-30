{
  # Opacity and blurring works! The trick is to not use FadeInactive in
  # xmonad settings and to use a blur method that's actually avaiable
  # (see picom --help).
  services.picom = {
    enable = true;
    activeOpacity = "1.0";
    inactiveOpacity = "1.0";
    backend = "glx";
    fade = true;
    fadeDelta = 5;
    shadow = true;
    shadowOpacity = "1.0";
  };
}
