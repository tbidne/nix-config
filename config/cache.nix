{
  nix.settings.substituters = [
    "https://nixcache.reflex-frp.org"
    "https://cache.nixos.org"
    "https://cache.iog.io"
    # Added for haskell.nix as IOG's was not working for ghc 9.4.4
    # See https://github.com/input-output-hk/haskell.nix/issues/1824
    "https://cache.zw3rk.com"
  ];

  nix.settings.trusted-public-keys = [
    "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI="
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
    "loony-tools:pr9m4BkM/5/eSTZlkQyRt57Jz7OMBxNSUiMC4FkcNfk="
  ];

  # Don't fail if cache is down. This does not seem to work reliably.
  # See: https://github.com/NixOS/nix/issues/3514
  nix.settings.fallback = true;
}
