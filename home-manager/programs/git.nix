{
  programs.git = {
    enable = true;
    userName = "Tommy Bidne";
    extraConfig = {
      pull.ff = "only";
      push.default = "simple";
      diff.tool = "vscode";
      difftool.vscode.cmd = "codium --wait --diff $LOCAL $REMOTE";
      merge.tool = "vscode";
      mergetool.vscode.cmd = "codium --wait $MERGED";
      core.editor = "codium";
    };
    aliases = {
      s = "status";
      b = "branch";
      gad = "add -A";
      co = "checkout";
      cob = "checkout -b";
      count = "count-objects -vH";
      count-commits = "rev-list --count";
      ft = "fetch --prune";
      mst = "merge origin/master --ff-only";
      l = "log";
      log-mst = "log origin/master";
      log-mst-me = "log origin/master --author='Tommy Bidne'";
      log-me = "log --author='Tommy Bidne'";
      df = "diff";
      dfc = "diff --cached";
      dft = "difftool";
      dftc = "difftool --cached";
    };
  };
}
