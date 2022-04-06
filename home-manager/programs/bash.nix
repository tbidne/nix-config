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
      nap = "systemctl suspend";

      # shell-run
      # legend defined in shell-run.nix
      srun = "shell-run -ck -fd";
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

      # runs nix-hs-tools where first arg is tool and the rest are args
      function hs() {
        nix run github:tbidne/nix-hs-tools/0.1.0.0#$1 -- ''${@:2}
      }

      # reload ui
      function rui() {
        sudo systemctl restart display-manager
      }

      # tries param command until it succeeds
      function retry() {
        success=0
        count=1
        while [[ $success == 0 ]]; do
          $@
          if [[ $? == 0 ]]; then
            echo "'$@' succeeded on try $count"
            success=1
          else
            echo "'$@' failed on try $count"
            sleep 1
          fi
          count=$((count + 1))
        done
      }

      # force pushes all changes, copies the new git revision into the clipboard
      function git-yolo() {
        git add -A && \
          git commit --amend --no-edit && \
          git push --force && \
          git log \
            | head -n 1 \
            | cut -c 8-47 \
            | xclip -selection clipboard
      }

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
