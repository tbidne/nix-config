let
  base-mb = 1024;  # size is in megabytes, base-mb = 1 gb
  sys-ram-gb = 16; # system has 16gb ram
  factor = 2;      # rule-of-thumb: swap = 2 * ram
in
{
  swapDevices = [
    {
      device = "/swapfile";
      size = base-mb * sys-ram-gb * factor;
    }
  ];
}
