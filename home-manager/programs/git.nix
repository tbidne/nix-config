{
  programs.git = {
    enable = true;
    signing = {
      key = "52734F12916B7BF7625B89FD15F2DFE933B0BF0B";
      signByDefault = true;
    };
    userName = "Tommy Bidne";
    userEmail = "tbidne@protonmail.com";
    extraConfig = {
      pull.ff = "only";
      push.default = "simple";
      diff.tool = "vscode";
      difftool.vscode.cmd = "codium --wait --diff $LOCAL $REMOTE";
      merge.tool = "vscode";
      mergetool.vscode.cmd = "codium --wait $MERGED";
      core.editor = "codium --wait";
    };
    aliases = {
      s = "status";
      b = "branch";
      gad = "add -A";
      gadp = "add -A --patch";
      co = "checkout";
      cob = "checkout -b";
      count = "count-objects -vH";
      count-commits = "rev-list --count";
      ff = "merge @{u} --ff-only";
      m = "merge --ff-only";
      ft = "fetch --prune";
      l = "log";
      log-me = "log --author='Tommy Bidne'";
      df = "diff";
      dfc = "diff --cached";
      dft = "difftool";
      dftc = "difftool --cached";
      lol = "log --oneline";
      redo = "commit --amend --no-edit";
      sm = "submodule update --init --recursive";

      # r = <remote>
      # u = upstream
      # b = <branch>
      # c = $current_branch

      # fast-forward param remote + param branch
      ffrb = "!f() { git fetch $1 --prune; git merge $1/$2 --ff-only; }; f";

      # fast-forward fixed remote 'upstream' + param branch
      ffub = "!f() { git fetch upstream --prune; git merge upstream/$1 --ff-only; }; f";

      # fast-forward fixed remote 'upstream' + current branch
      ffuc = ''
        !f() {
          curr_branch=$(git rev-parse --abbrev-ref HEAD)
          git fetch upstream --prune
          git merge upstream/$curr_branch --ff-only
        }
        f
      '';

      # fast-forward fixed param remote + current branch
      ffrc = ''
        !f() {
          curr_branch=$(git rev-parse --abbrev-ref HEAD)
          git fetch $1 --prune
          git merge $1/$curr_branch --ff-only
        }
        f
      '';

      # e.g. git log-date "2021-07-27 12:00" "master"
      log-date = "!f() { git rev-list -n 1 --before=\"$1\" $2; }; f";
      # e.g. git log-del-str "some deleted string"
      log-del-str = "!f() { git log -S \"$1\"; }; f";
      # e.g. git log-del-file "deleted-file"
      log-del-file = "!f() { git log --diff-filter=D -- \"$1\"; }; f";
    };
  };
}
