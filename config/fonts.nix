{ inputs }:

{
  # Brave occasionally crashes with the error (journalctl -r):
  #
  #     Feb 25 17:10:07 nixos brave[781694]: Fontconfig error: Cannot load default config file: File not found
  #
  # For now, I have run 'fc-cache -r -v'. If that does not work, try setting
  # fonts.fontDir.enable.
  #
  # https://nixos.wiki/wiki/Fonts
  # https://github.com/NixOS/nixpkgs/issues/176081
  fonts.packages = with inputs.pkgs; [
    aileron
    carlito
    font-awesome
    hasklig
    (inputs.src2pkg inputs.impact)
    (inputs.src2pkg inputs.ringbearer)
    vista-fonts
  ];
}
