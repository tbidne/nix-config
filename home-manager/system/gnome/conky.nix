{ inputs }:

let
  pkgs = inputs.pkgs;
in
{
  # conky files
  home.file.".config/conky/conkyrc_left.conf" = {
    source = "${inputs.conky.outPath}/conkyrc_left.conf";
  };
  home.file.".config/conky/conkyrc_right.conf" = {
    source = "${inputs.conky.outPath}/conkyrc_right.conf";
  };
  home.file.".config/conky/conkyrc_draw.lua" = {
    source = "${inputs.conky.outPath}/conkyrc_draw.lua";
  };

  home.file.".config/conky/startup.sh" = {
    executable = true;
    text = ''
      #!${pkgs.bash}/bin/bash
      conky -d -c /home/tommy/.config/conky/conkyrc_left.conf
      conky -d -c /home/tommy/.config/conky/conkyrc_right.conf
    '';
  };

  # startup
  home.file.".config/autostart/conky.sh.desktop" = {
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
      Name[en_US]=conky.sh
      Name=conky.sh
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
