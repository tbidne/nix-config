{ inputs }:

{
  fonts.fonts = with inputs.pkgs;
    [
      aileron
      carlito
      emacs-all-the-icons-fonts
      font-awesome
      hasklig
      inputs.impact.defaultPackage.${inputs.system}
      inputs.ringbearer.defaultPackage.${inputs.system}
      siji
      unifont
      vistafonts
      # openweathermap
      weather-icons
    ];
}
