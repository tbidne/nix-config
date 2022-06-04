{
  services.picom = {
    enable = true;
    activeOpacity = "1.0";
    inactiveOpacity = "1.0";
    backend = "glx";
    fade = true;
    fadeDelta = 5;
    shadow = true;
    shadowOpacity = "1.0";
    # We want this enabled even if we are not using anything fancy like
    # blur or transparency as experimental is "better behaved". If we do
    # not have this enabled then the journalctl logs get spammed with
    # picom errors like:
    #
    # glx_bind_pixmap ERROR Failed to query info of pixmap 0x0080058c.
    # paint_one ERROR Window 0x01600003 is missing painting data.
    # paint_one ERROR Failed to bind texture for window 0x01600003.
    #
    # See https://github.com/yshui/picom/issues/407.
    experimentalBackends = true;
  };
}
