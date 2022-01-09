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
    };
  };
}
