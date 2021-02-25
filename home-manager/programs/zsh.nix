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
      source ~/.bashrc.private.interos

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

      neofetch
      cd /etc/nixos
    '';
  };
}