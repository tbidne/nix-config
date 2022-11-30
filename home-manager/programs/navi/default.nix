{ inputs }:

let
  pkgs = inputs.pkgs;
in
{
  home.file.".config/navi/config.toml" = {
    source = ./config.toml;
  };

  home.file.".config/navi/startup.sh" = {
    executable = true;
    text = ''
      #!${pkgs.bash}/bin/bash
      navi
    '';
  };

  # plasma startup
  home.file.".config/autostart/navi.sh.desktop" = {
    executable = true;
    text = ''
      [Desktop Entry]
      Comment[en_US]=
      Comment=
      Exec=/home/tommy/.config/navi/startup.sh
      GenericName[en_US]=
      GenericName=
      Icon=dialog-scripts
      MimeType=
      Name[en_US]=navi.sh
      Name=navi.sh
      Path=
      StartupNotify=true
      Terminal=false
      TerminalOptions=
      Type=Application
      X-DBUS-ServiceName=
      X-DBUS-StartupType=
      X-KDE-AutostartScript=true
      X-KDE-SubstituteUID=false
      X-KDE-Username=
    '';
  };
}
