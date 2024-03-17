{
  home.file = {
    ".ghci".text = ''
      -- prompt
      :set prompt "\ESC[1;34m%s\n\ESC[0;34mλ. \ESC[m"

      -- turn off warnings
      :set -w

      :set -fprint-explicit-foralls

      -- common extensions
      :set -XOverloadedStrings
      :set -XImportQualifiedPost
      :set -XNoStarIsType

      -- multi-line support
      :set +m -v0

      -- profiling
      -- :set +s

      -- Type interferes with ghc tests, so for now we leave it off
      -- by default
      -- type
      -- :set +t
    '';
  };
}
