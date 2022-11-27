{ inputs }:

let
  pkgs = inputs.pkgs;
in
{
  # conky files
  home.file.".config/conky/conky_left.conf" = {
    source = ./conky_left.conf;
  };
  home.file.".config/conky/conky_right.conf" = {
    source = ./conky_right.conf;
  };
  home.file.".config/conky/conky.lua" = {
    source = ./conky.lua;
  };

  home.file.".config/conky/startup.sh" = {
    executable = true;
    text = ''
      #!${pkgs.bash}/bin/bash
      conky -d -c /home/tommy/.config/conky/conky_left.conf
      conky -d -c /home/tommy/.config/conky/conky_right.conf
    '';
  };

  # plasma startup
  home.file.".config/autostart/startup.sh.desktop" = {
    executable = true;
    text = ''
      [Desktop Entry]
      Comment[en_US]=
      Comment=
      Exec=/home/tommy/.config/conky/startup.sh
      GenericName[en_US]=
      GenericName=
      Icon=dialog-scripts
      MimeType=
      Name[en_US]=startup.sh
      Name=startup.sh
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
