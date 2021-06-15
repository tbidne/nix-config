{
  programs.git = {
    enable = true;
    userName = "Tommy Bidne";
    extraConfig = {
      pull.ff = "only";
      push.default = "simple";
      diff.tool = "nvimdiff";
      difftool.nvimdiff.cmd = "nvim -d $LOCAL $REMOTE";
      difftool.trustExitCode = true;
      merge.tool = "nvimdiff";
      mergetool.prompt = true;
      mergetool.nvimdiff.cmd = "nvim -d $LOCAL $REMOTE $MERGED";
      core.editor = "nvim";
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
