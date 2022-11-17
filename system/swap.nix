let
  # size is in megabytes, base-mb = 1 gb
  base-mb = 1024;
  # system has 16gb ram
  sys-ram-gb = 16;
  # typical rule-of-thumb is 'swap = 2 * ram', but 32gb swap seems
  # unnecessary, so we'll go with 16 for now.
  factor = 1;
in
{
  swapDevices = [
    {
      device = "/swapfile";
      size = base-mb * sys-ram-gb * factor;
    }
  ];
}
