{
  home.file = {
    ".config/shell-run/shell-run.legend".text = ''
      # nixos-rebuild
      sys-test=sudo nixos-rebuild test --flake '.#nixos'
      sys-switch=sudo nixos-rebuild switch --flake '.#nixos'
      sys-clean=nix-collect-garbage --delete-older-than 30d
      sys-clean-all=sudo nix-collect-garbage -d

      # nix shell
      ns=nix-shell --command exit

      # don't know how to call exit here...somehow have to make sure it's
      # in the flake (add core-utils somehow?)
      nd=nix develop -c bash -c 'exit'

      # misc
      nix-revw-hd=nix-shell -p nixpkgs-review --run "nixpkgs-review rev HEAD"
      nw-comparison=PYTHONPATH=. python application/db_scripts/load_market_comparison.py
    '';
  };
}
