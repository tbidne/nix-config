{
  programs.virt-manager.enable = true;

  virtualisation = {
    # vert-manager
    #
    # Note: Want to install guest-agent on VM, e.g. for ubuntu guest after
    # startup:
    #
    #   sudo aptitude update
    #   sudo aptitude install qemu-guest-agent
    #
    # https://nixos.wiki/wiki/Virt-manager
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;

    virtualbox = {
      host = {
        enable = true;
        # The extension pack is unfree, hence requires a (n expensive)
        # rebuild. Hence disabling it unless we need it.
        #enableExtensionPack = true;
      };
    };
  };
}
