{ inputs }:

{
  fonts.fonts = with inputs.pkgs;
    [
      aileron
      carlito
      emacs-all-the-icons-fonts
      font-awesome
      hasklig
      (inputs.src2pkg inputs.impact)
      (inputs.src2pkg inputs.ringbearer)
      siji
      unifont
      vistafonts
      # openweathermap
      weather-icons
    ];
}
