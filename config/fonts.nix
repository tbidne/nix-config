{ pkgs, ... }:

let
  ringbearerRepo = builtins.fetchGit {
    url = "https://github.com/tbidne/ringbearer.git";
    ref = "main";
    rev = "d34a126bc5719f1f5ac9f9203617c9ccfaf35f11";
  };
  ringbearer = pkgs.callPackage ringbearerRepo {};
in
{
  fonts.fonts = with pkgs;
    [ aileron
      font-awesome
      hasklig
      ringbearer
      siji
      unifont
      # openweathermap
      weather-icons
    ];
}