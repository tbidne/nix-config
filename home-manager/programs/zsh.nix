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
    initExtra = ''
      export FZF_DEFAULT_COMMAND='rg --files --hidden'

      cd /etc/nixos
    '';
  };
}
