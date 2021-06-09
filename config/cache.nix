{
  nix.binaryCaches =
    [
      "https://nixcache.reflex-frp.org"
      "https://cache.nixos.org"
      "https://shpadoinkle.cachix.org"
      "https://hydra.iohk.io"
    ];

  nix.binaryCachePublicKeys =
    [
      "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "shpadoinkle.cachix.org-1:aRltE7Yto3ArhZyVjsyqWh1hmcCf27pYSmO1dPaadZ8="
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
    ];
}
