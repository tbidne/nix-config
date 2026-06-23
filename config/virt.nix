{
  virtualisation.virtualbox = {
    host = {
      enable = true;
      # The extension pack is unfree, hence requires a (n expensive)
      # rebuild. Hence disabling it unless we need it.
      #enableExtensionPack = true;
    };
  };
}
