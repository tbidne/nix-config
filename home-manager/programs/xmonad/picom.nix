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
    opacityRule = [
      "75:class_g *= 'kitty'"
    ];
    shadow = true;
    shadowOpacity = "0.75";

    blur = true;
    experimentalBackends = true;
    # dual_kawase is probably the blur method we want, but it's not in
    # picom 8.2 (current version). Once we have that we should swap it for
    # "box".
    extraOptions = ''
      blur =
        { method = "box";
          size = 10;
          deviation = 5.0;
        };
    '';
  };
}
