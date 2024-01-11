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

      -- multi-line support
      :set +m -v0

      -- profiling
      -- :set +s

      -- type
      :set +t
    '';
  };
}
