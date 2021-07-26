{ secrets, ... }:

{
  imports = [
    ./config.nix

    (import ./openweathermap.nix { inherit secrets; })
  ];
}
