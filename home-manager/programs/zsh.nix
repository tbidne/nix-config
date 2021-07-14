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
      sys-test = "shell-run -ck -l ~/dev/legend.txt sys-test";
      sys-switch = "shell-run -ck -l ~/dev/legend.txt sys-switch";
      sys-clean = "shell-run -ck -l ~/dev/legend.txt sys-clean";
      sys-clean-all = "shell-run -ck -l ~/dev/legend.txt sys-clean-all";
    };
    initExtra = ''
      export FZF_DEFAULT_COMMAND='rg --files --hidden'

      cd /etc/nixos
    '';
  };
}
