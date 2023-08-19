{ inputs }:

{
  fonts.packages = with inputs.pkgs;
    [
      aileron
      carlito
      font-awesome
      hasklig
      (inputs.src2pkg inputs.impact)
      (inputs.src2pkg inputs.ringbearer)
      vistafonts
    ];
}
