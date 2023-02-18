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
      doom = "~/.emacs.d/bin/doom";
      lightup = "brightnessctl -d intel_backlight s +10%";
      lightdown = "brightnessctl -d intel_backlight s 10%-";
      es = "emacs . &";
      hls = "haskell-language-server";
      nap = "systemctl suspend";
      nixfork = "cd ~/Dev/opensource/my-forks/nixpkgs";
      nv = "nvim .";
      pwdc = "pwd | xclip -selection clipboard";
      reload-ui = "sudo systemctl restart display-manager";
      vsc = "codium .";
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
        nix run github:tbidne/nix-hs-tools/0.7#$1 -- ''${@:2}
      }

      # Launches a nix shell using those defined in my external repo.
      # The first arg is the shell and the rest are passed through. E.g.
      #
      # hs-nshell liquidhaskell
      # hs-nshell liquidhaskell --arg dev false
      function hs-nshell() {
        nix-shell http://github.com/tbidne/nix-hs-shells/archive/main.tar.gz -A $1 ''${@:2}
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

      function cghcid() {
        ghcid --command "cabal repl $@"
      }

      function crepl() {
        cabal repl $@
      }

      function ns() {
        nix-shell $@
      }

      function nd() {
        nix develop $@
      }

      function nu() {
        nix flake lock --update-input $@
      }

      function nus() {
        srcs=""
        for src in "$@"; do
          srcs+=" --update-input $src"
        done
        nix flake lock $srcs
      }

      # find-replace
      function fr() {
        find . \
          -type f -name '*' ! -path "./.*" ! -path "./dist-newstyle/*" \
            | xargs sed -i "s/$1/$2/g"
      }

      # Update per https://github.com/badges/shields/issues/8671
      function update-badges() {
        find . \
          -type f -name '*md' ! -path "./.*" ! -path "./dist-newstyle/*" \
            | xargs sed -i -E 's/https:\/\/img.shields.io\/github\/workflow\/status\/([a-zA-Z0-9_-]+)\/([a-zA-Z0-9_-]+)\/([a-zA-Z0-9_-]+)\/([a-zA-Z0-9_-]+)\?(.*)/http:\/\/img.shields.io\/github\/actions\/workflow\/status\/\1\/\2\/\3.yaml\?branch=\4\&\5/g'
      }

      function del-hs() {
        find . \
          -type d -name .stack-work -o -name dist-newstyle \
            | xargs rm -r

        rm -r ~/.cabal
        rm -r ~/.stack
      }

      function large-dirs() {
        du -sh ./* | grep [0-9\.]G
      }

      # Turns a symlink into a real file. Useful for testing changes to config
      # files that are managed by nix e.g.
      #
      # unsym-f some-config
      #
      # # test some-config changes...
      #
      # After we are satisfied w/ the changes, we can make the same changes to
      # our nix file then delete the temp some-config.
      function unsym-f() {
        [ -L "$1" ] && cp --remove-destination $(readlink $1) $1
        chmod a+rw $1
      }

      # applies unsym-f to all files in the current directory
      function unsym-d() {
        for f in $(find -type l); do
          cp --remove-destination $(readlink $f) $f
          chmod a+rw $f
        done
      }

      function plasma-nix() {
        nix run github:pjones/plasma-manager
      }

      # Runs haddock job and pushes docs to gh-pages branch. Assumes
      # the following:
      #
      # - main branch is 'main'
      # - pages branch is 'gh-pages'
      # - haddock script is 'make haddock' (i.e. makefile and cabal)
      # - remote is 'origin'
      function haddock-push() {
        git checkout main && \
        git branch -D gh-pages && \
          git checkout -b gh-pages && \
          make haddock && \
          git add -A && \
          git commit -m "Add haddocks" && \
          git push -u --force origin gh-pages && \
          git checkout main
      }

      source ~/.git-prompt.sh
    '';
    initExtra = ''
      export FZF_DEFAULT_COMMAND='rg --files --hidden'
      export LESS='-r'
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
