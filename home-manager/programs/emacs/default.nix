{
  # NOTE:
  #
  # - It would be nice if we could install doom the same way as everything
  #   else. This is in fact possible, but it requires some messy logic:
  #
  #   https://discourse.nixos.org/t/advice-needed-installing-doom-emacs/8806
  #
  #   A better way would be to include the repo as a flake input, though that
  #   is even more convoluted as we need the install directory to be writable
  #   (not possible w/ nix/store, so we'd need to wrapPackage).
  #
  #   For now, we just install it imperatively and have the config declarative.
  #
  # - Also, on installation we do not want doom installed w/ the env var option,
  #   as this seems to conflict with nix shell vars (e.g. hls).
  home.file.".doom.d/config.el" = {
    source = ./config.el;
  };
  home.file.".doom.d/init.el" = {
    source = ./init.el;
  };
  home.file.".doom.d/packages.el" = {
    source = ./packages.el;
  };
}
