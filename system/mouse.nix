{
  # touchpad
  services.xserver.libinput.touchpad = {
    # -1.0 to 1.0, helps touchpad accel on HiDPI
    accelSpeed = "0.5";
    middleEmulation = true;
    naturalScrolling = true;
    tapping = true;
  };
}
