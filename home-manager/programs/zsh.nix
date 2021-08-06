{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    history.extended = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git-extras"
        "git"
        "gitfast"
      ];
      theme = "avit";
    };
    shellAliases = {
      # kitty
      icat = "kitty +kitten icat";

      # misc
      ns-time = "shell-run -ck \"nix-shell --command exit\"";

      # shell-run
      sys-test = "shell-run -ck -l ~/Dev/legend.txt sys-test";
      sys-switch = "shell-run -ck -l ~/Dev/legend.txt sys-switch";
      sys-clean = "shell-run -ck -l ~/Dev/legend.txt sys-clean";
      sys-clean-all = "shell-run -ck -l ~/Dev/legend.txt sys-clean-all";
    };
    initExtra = ''
      export FZF_DEFAULT_COMMAND='rg --files --hidden'

      cd /etc/nixos
    '';
  };
}
