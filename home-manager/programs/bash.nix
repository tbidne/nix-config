{
  programs.bash = {
    enable = true;
    historySize = 100000;
    shellAliases = {
      # kitty
      icat = "kitty +kitten icat";

      # misc
      ns-time = "shell-run -ck \"nix-shell --command exit\"";
      nd-time = "shell-run -ck \"nix develop --command exit\"";

      # shell-run
      sys-test = "shell-run -k -l ~/Dev/legend.txt sys-test";
      sys-switch = "shell-run -k -l ~/Dev/legend.txt sys-switch";
      sys-clean = "shell-run -k -l ~/Dev/legend.txt sys-clean";
      sys-clean-all = "shell-run -k -l ~/Dev/legend.txt sys-clean-all";
    };
    bashrcExtra = ''
      bind '"\e[A": history-search-backward'
      bind '"\e[B": history-search-forward'
    '';
    initExtra = ''
      export FZF_DEFAULT_COMMAND='rg --files --hidden'
      export LESS='-r'

      cd /etc/nixos
    '';
    shellOptions =
      [ "autocd"
        "cdspell"
        "cmdhist"
      ];
  };
}
