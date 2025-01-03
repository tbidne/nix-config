{ pkgs, ... }:

{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql;
    authentication = pkgs.lib.mkForce ''
      local all all trust
      host  all all 127.0.0.1/32 trust
      host  all all ::1/128      trust
      host  all all 0.0.0.0/0    trust
    '';
  };
}
