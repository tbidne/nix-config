{ inputs }:

{
  programs.firefox = {
    enable = true;

    # For some reason this doesn't appear to work at the moment...
    # Leaving it in as we will likely want something like this in the future.
    extensions = with (inputs.pkgs.nur.repos.rycee.firefox-addons); [
      cookie-autodelete
      darkreader
      decentraleyes
      #https-everywhere
      lastpass-password-manager
      link-cleaner
      noscript
      #nordvpn
      privacy-badger
      ublock-origin
    ];

    profiles = {
      default = {
        # If this option is on then the UI is horrid (HiDPI basically does
        # not work). Maybe it's related to extension not working though?
        #isDefault = true;
        settings = {
          "browser.tabs.closeWindowWithLastTab" = true;
          "browser.urlbar.placeholderName" = "DuckDuckGo";
          "privacy.donottrackheader.enabled" = true;
          "privacy.donottrackheader.value" = 1;
          "privacy.firstparty.isolate" = true;
          "signon.rememberSignons" = false;
        };

        path = "zydwxfxy.default";
      };
    };
  };
}
