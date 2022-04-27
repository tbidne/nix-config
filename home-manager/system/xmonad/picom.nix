{
  # Opacity and blurring works! The trick is to not use FadeInactive in
  # xmonad settings and to use a blur method that's actually avaiable
  # (see picom --help).
  services.picom = {
    enable = true;
    activeOpacity = "0.90";
    inactiveOpacity = "0.90";
    backend = "glx";
    fade = true;
    fadeDelta = 5;
    # Using 'name' for Gimp, LibreOffice since I'm not sure what the class
    # class should be.
    opacityRule = [
      "100:class_g *= 'Chromium'"
      "100:class_g *= 'Brave'"
      "100:name    *= 'Mozilla Firefox'"
      "100:name    *= 'Thunderbird'"
      "100:name    *= 'Google Chrome'"
      "100:name    *= 'GNU Image Manipulation Program'"
      "100:name    *= 'LibreOffice'"
      "75:class_g  *= 'kitty'"
    ];
    shadow = true;
    shadowOpacity = "0.75";

    blur = true;
    experimentalBackends = true;
    extraOptions = ''
      blur =
        { method = "dual_kawase";
          strength = 7;
        };
    '';
  };
}
