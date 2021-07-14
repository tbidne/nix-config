{ pkgs, system, ringbearer, ... }:

{
  fonts.fonts = with pkgs;
    [
      aileron
      carlito
      font-awesome
      hasklig
      ringbearer.defaultPackage.${system}
      siji
      unifont
      # openweathermap
      weather-icons
    ];
}
