{
  services.xserver.libinput = {
    enable = true;

    mouse = {
      # This doesn't seem to work, but this is probably what we eventually
      # want, so leaving it for now.
      naturalScrolling = true;
    };

    touchpad = {
      # -1.0 to 1.0, helps touchpad accel on HiDPI
      accelSpeed = "0.5";
      middleEmulation = true;
      naturalScrolling = true;
      tapping = true;
    };
  };
}
