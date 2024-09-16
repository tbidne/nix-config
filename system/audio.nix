{ pkgs, ... }:

{
  # Not entirely sure I need all of this enabled, but this apparently works.
  # Pulseaudio is removed since it conflicts with some other gnome setting,
  # as it is now the default in gnome. Note that the ui needs to be reloaded
  # (reload-ui) to see changes.
  #
  # See https://nixos.wiki/wiki/PipeWire.
  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
}
