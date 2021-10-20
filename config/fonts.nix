{ pkgs, system, ringbearer, impact, ... }:

{
  fonts.fonts = with pkgs;
    [
      aileron
      carlito
      emacs-all-the-icons-fonts
      font-awesome
      hasklig
      impact.defaultPackage.${system}
      ringbearer.defaultPackage.${system}
      siji
      unifont
      vistafonts
      # openweathermap
      weather-icons
    ];
}
