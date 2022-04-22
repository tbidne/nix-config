{
  programs.git = {
    enable = true;
    signing = {
      key = "F667A914B16C8D23";
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
      co = "checkout";
      cob = "checkout -b";
      count = "count-objects -vH";
      count-commits = "rev-list --count";
      ff = "merge @{u} --ff-only";
      ft = "fetch --prune";
      l = "log";
      log-me = "log --author='Tommy Bidne'";
      df = "diff";
      dfc = "diff --cached";
      dft = "difftool";
      dftc = "difftool --cached";

      # e.g. git log-date "2021-07-27 12:00" "master"
      log-date = "!f() { git rev-list -n 1 --before=\"$1\" $2; }; f";
      # e.g. git log-del-str "some deleted string"
      log-del-str = "!f() { git log -S \"$1\"; }; f";
      # e.g. git log-del-file "deleted-file"
      log-del-file = "!f() { git log --diff-filter=D -- \"$1\"; }; f";
    };
  };
}
