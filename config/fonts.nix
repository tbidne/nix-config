{ pkgs, ... }:

let
  ringbearerRepo = builtins.fetchGit {
    url = "https://github.com/tbidne/ringbearer.git";
    ref = "main";
    rev = "10e60077b49bf36765eada7b4757b8b45fbd98a9";
  };
  ringbearer = pkgs.callPackage ringbearerRepo {};
in
{
  fonts.fonts = with pkgs;
    [ hasklig
      ringbearer
    ];
}