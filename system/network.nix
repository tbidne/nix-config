{ inputs }:

{
  networking = {
    hostName = "nixos"; # Define your hostname.
    networkmanager = {
      enable = true;

      # For using openvpn manually. TLDR:
      #
      # 1. Download openvpn profiles, import as network connection:
      #
      #    sudo wget https://downloads.nordcdn.com/configs/archives/servers/ovpn.zip
      #
      # 2. Add nord creds to connection (NOT the normal username/password).
      #
      #    https://my.nordaccount.com/dashboard/nordvpn/manual-configuration/service-credentials/
      #
      # See:
      #
      # https://support.nordvpn.com/hc/en-us/articles/20347784574097-Connecting-to-NordVPN-Linux-Network-Manager
      plugins = [ inputs.pkgs.networkmanager-openvpn ];
    };

    # Manually had these when I was getting presumed DNS errors via nix i.e.
    # I was on some hotel wifi and nix commands were receiving HTTP 503
    # from curl, "could not resolve host" e.g. hackage, http://www.github.com.
    #
    # Weirdly, I could curl these myself no problem. Moreover, the internet
    # itself was quite bad i.e. google would not load, github was formatted
    # badly (e.g. images would not load). My phone was fine, however.
    #
    # My _guess_ is some bad configuration between the laptop and the wifi,
    # but a workaround ended up being a vpn (because better DNS?). In any
    # case, it might make sense to have these as a backup.
    nameservers = [
      "8.8.8.8"
    ];

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    interfaces.enp0s31f6.useDHCP = true;
    interfaces.wlp0s20f3.useDHCP = true;

    #services.tailscale.enable = true;

    # Due to build warning:
    #
    # warning: Strict reverse path filtering breaks Tailscale exit node use and
    # some subnet routing setups. Consider setting
    # `firewall.checkReversePath` = 'loose'
    #firewall.checkReversePath = "loose";
    firewall.enable = false;
  };

  # Without this, we receive errors about switching to the new build since
  # nm-online never succeeds.
  systemd.services.NetworkManager-wait-online.enable = false;
}
