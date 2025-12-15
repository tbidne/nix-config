{
  home.file = {
    ".bash_functions.sh" = {
      source = ./bash/functions.sh;
    };

    # Command as we want systemd-inhibit to be able to see it.
    ".local/bin/pid_poll.sh" = {
      executable = true;
      source = ./bash/pid_poll.sh;
    };
  };

  programs.bash = {
    enable = true;
    historySize = 100000;
    shellAliases = {
      # kitty
      icat = "kitty +kitten icat";

      # misc
      reload = ". ~/.bashrc";
      lightup = "brightnessctl -d intel_backlight s +10%";
      lightdown = "brightnessctl -d intel_backlight s 10%-";
      hls = "haskell-language-server";
      nap = "systemctl suspend";
      nixfork = "cd ~/Dev/opensource/my-forks/nixpkgs";
      pwdc = "pwd | xclip -selection clipboard";
      reload-ui = "sudo systemctl restart display-manager";
      vsc = "codium .";
    };

    bashrcExtra = ''
      # Load completions for my projects
      . <(charon --bash-completion-script `which charon`)
      . <(kairos --bash-completion-script `which kairos`)
      . <(pacer --bash-completion-script `which pacer`)
      . <(path-size --bash-completion-script `which path-size`)
      . <(pythia --bash-completion-script `which pythia`)
      . <(navi --bash-completion-script `which navi`)
      . <(shrun --bash-completion-script `which shrun`)
      . <(todo --bash-completion-script `which todo`)

      export PATH=$PATH:~/.local/bin

      . ~/.bash_functions.sh
    '';
    initExtra = ''
      export FZF_DEFAULT_COMMAND='rg --files --hidden'
      export LESS='-r'
      export XDG_CONFIG_HOME=/home/tommy/.config
    '';
    shellOptions = [
      "autocd"
      "cdspell"
      "cmdhist"
    ];
  };

  programs.readline = {
    enable = true;
    extraConfig = ''
      set completion-ignore-case on
    '';
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      add_newline = true;
      character = {
        success_symbol = "[λ.](bold green)"; # ➜
        error_symbol = "[λ.](bold red)";
      };
      shlvl = {
        disabled = false;
      };
    };
  };
}
