{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    history.extended = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git-extras"
        "git"
        "gitfast"
      ];
      theme = "avit";
    };
    initExtra = ''
      alias nsCabal2Nix='nix-shell --pure -p cabal2nix --run "cabal2nix ." > default.nix'

      # mv to trash
      del() {
        local filePath=$(readlink -f $1);
        local trash="/home/tommy/.local/share/Trash"

        # create meta data
        local currTime=$(date --iso-8601=hours)

        local metaTitle="[Trash Info]"
        local metaPathInfo="Path=$filePath"
        local metaDate="DeletionDate=$currTime"

        local metaPayload="$metaTitle\n$metaPathInfo\n$metaDate"
        local metaPath="$trash/info/$1.trashinfo"

        $(echo $metaPayload > $metaPath)

        # move file to trash
        $(mv $filePath "$trash/files")
      }

      cd /etc/nixos
    '';
  };
}
