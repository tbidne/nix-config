{
  # NOTE: [GHC Cache]
  #
  # The GHC cachix key changed, which caused some cache failures. The solution
  # was to comment out the ghc-nix lines below (removing it from
  # /etc/nix/nix.conf), then adding it back with the new key. In general,
  # this seems like the way forward as merely updating the key appears to
  # leave the old key present, which takes priority, hence will fail.
  #
  # For other cache failures, ensure ~/config/nix/nix.conf does not contain
  # outdated refs.
  #
  # See NOTE: [Cachix].
  nix.settings.substituters = [
    "https://nixcache.reflex-frp.org"
    "https://cache.nixos.org"
    "https://cache.iog.io"
    "https://ghc-nix.cachix.org"
  ];

  nix.settings.trusted-public-keys = [
    "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI="
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
    "ghc-nix.cachix.org-1:wI8l3tirheIpjRnr2OZh6YXXNdK2fVQeOI4SVz/X8nA="
  ];

  # Don't fail if cache is down. This does not seem to work reliably.
  # See: https://github.com/NixOS/nix/issues/3514
  nix.settings.fallback = true;
}
