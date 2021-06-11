{
  programs.git = {
    enable = true;
    userName = "Tommy Bidne";
    extraConfig = {
      pull.ff = "only";
      push.default = "simple";
      merge.tool = "vimdiff";
      mergetool.path = "nvim";
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
