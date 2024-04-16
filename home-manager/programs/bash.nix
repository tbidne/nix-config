{
  home.file = {
    ".bash_functions.sh" = {
      source = ./bash/functions.sh;
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
