{
  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  services.tailscale.enable = true;

  # Without this, we receive errors about switching to the new build since
  # nm-online never succeeds.
  systemd.services.NetworkManager-wait-online.enable = false;

  # Due to build warning:
  #
  # warning: Strict reverse path filtering breaks Tailscale exit node use and
  # some subnet routing setups. Consider setting
  # `networking.firewall.checkReversePath` = 'loose'
  #networking.firewall.checkReversePath = "loose";
}
