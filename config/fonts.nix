{ pkgs, system, ringbearer, ... }:

{
  fonts.fonts = with pkgs;
    [
      aileron
      carlito
      emacs-all-the-icons-fonts
      font-awesome
      hasklig
      ringbearer.defaultPackage.${system}
      siji
      unifont
      vistafonts
      # openweathermap
      weather-icons
    ];
}
