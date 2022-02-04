let
  git-prompt = builtins.readFile ./git_prompt.sh;
in
{
  home.file = {
    ".git-prompt.sh".text = ''
      ${git-prompt}
    '';
  };

  programs.bash = {
    enable = true;
    historySize = 100000;
    shellAliases = {
      # kitty
      icat = "kitty +kitten icat";

      # misc
      pwdc = "pwd | xclip -selection clipboard";

      # shell-run
      ns-time = "shell-run  \"nix-shell --command exit\"";
      nd-time = "shell-run  \"nix develop --command exit\"";
      sys-test = "shell-run -k -l ~/Dev/legend.txt sys-test";
      sys-switch = "shell-run -k -l ~/Dev/legend.txt sys-switch";
      sys-clean = "shell-run -k -l ~/Dev/legend.txt sys-clean";
      sys-clean-all = "shell-run -k -l ~/Dev/legend.txt sys-clean-all";

      # haskell
      stylish-fmt = "find . -name '*.hs' -type f | xargs stylish-haskell --inplace";
    };
    bashrcExtra = ''
      function color_my_prompt {
          local __user_and_host="\[\033[01;32m\]\u@\h"
          local __cur_location="\[\033[01;34m\]\w"
          local __git_branch_color="\[\033[31m\]"
          #local __git_branch="\`ruby -e \"print (%x{git branch 2> /dev/null}.grep(/^\*/).first || \'\').gsub(/^\* (.+)$/, '(\1) ')\"\`"
          local __git_branch='`git branch 2> /dev/null | grep -e ^* | sed -E  s/^\\\\\*\ \(.+\)$/\(\\\\\1\)\ /`'
          local __prompt_tail="\[\033[35m\]\n$"
          local __last_color="\[\033[00m\]"
          export PS1="$__user_and_host $__cur_location $__git_branch_color$__git_branch$__prompt_tail$__last_color "
      }
      color_my_prompt

      source ~/.git-prompt.sh
      source ~/.bash_profile.private
    '';
    initExtra = ''
      export FZF_DEFAULT_COMMAND='rg --files --hidden'
      export LESS='-r'

      # old
      #PS1=\n\[\033[1;32m\][\[\e]0;\u@\h: \w\a\]\u@\h:\w]\$\[\033[0m\]
    '';
    shellOptions =
      [
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
}
