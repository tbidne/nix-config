{
  # Bluetooth is sometimes finicky. For example, one time I connected my
  # headphones but they failed to show up in the volume settings as an option.
  #
  # Disconnecting/reconnecting did not work, but restarting bluetooth itself
  # did. Also note that prior to working, the headphone's name in the bluetooth
  # settings was something like 'LE Bose ...' whereas after the restart
  # it was just 'Bose ...'.
  hardware.bluetooth.enable = true;
}
