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
      sys-test="shell-run -sk -l ~/Dev/legend.txt sys-test";
      sys-switch="shell-run -sk -l ~/Dev/legend.txt sys-switch";
    };
    initExtra = ''
      export FZF_DEFAULT_COMMAND='rg --files --hidden'

      cd /etc/nixos
    '';
  };
}
