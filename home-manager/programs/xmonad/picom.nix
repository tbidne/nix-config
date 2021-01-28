{
  services.picom = {
    enable = true;
    activeOpacity = "0.9";
    inactiveOpacity = "0.9";
    backend = "glx";
    fade = true;
    fadeDelta = 5;
    #opacityRule = [ "100:name *= 'i3lock'" ];
    shadow = true;
    shadowOpacity = "0.75";
  };
}