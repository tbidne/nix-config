{
  # Swap these once we can upgrade nixpkgs
  nix.settings.substituters = [
    "https://nixcache.reflex-frp.org"
    "https://cache.nixos.org"
    "https://shpadoinkle.cachix.org"
    "https://hydra.iohk.io"
    "https://iohk.cachix.org"
    "ssh://nix-ssh@ci.ardana.platonic.systems"
  ];

  nix.settings.trusted-public-keys = [
    "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI="
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "shpadoinkle.cachix.org-1:aRltE7Yto3ArhZyVjsyqWh1hmcCf27pYSmO1dPaadZ8="
    "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
    "iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo="
    "ci.ardana.platonic.systems:yByqhxfJ9KIUOyiCe3FYhV7GMysJSA3i5JRvgPuySsI="
  ];
}
