{
  services.libinput = {
    enable = true;

    # NOTE: Leaving this for documentation. It works for minimal setups but
    # not for desktop envs (that is handled by our home-manager settings).
    #mouse = {
    #  naturalScrolling = true;
    #};

    touchpad = {
      # -1.0 to 1.0, helps touchpad accel on HiDPI
      accelSpeed = "0.5";
      middleEmulation = true;
      naturalScrolling = true;
      tapping = true;
    };
  };
}
