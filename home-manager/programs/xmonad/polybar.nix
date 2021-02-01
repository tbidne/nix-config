{
  home.file = {
    ".config/polybar/config".text = ''
      ;==========================================================
      ;
      ;
      ;   ██████╗  ██████╗ ██╗  ██╗   ██╗██████╗  █████╗ ██████╗
      ;   ██╔══██╗██╔═══██╗██║  ╚██╗ ██╔╝██╔══██╗██╔══██╗██╔══██╗
      ;   ██████╔╝██║   ██║██║   ╚████╔╝ ██████╔╝███████║██████╔╝
      ;   ██╔═══╝ ██║   ██║██║    ╚██╔╝  ██╔══██╗██╔══██║██╔══██╗
      ;   ██║     ╚██████╔╝███████╗██║   ██████╔╝██║  ██║██║  ██║
      ;   ╚═╝      ╚═════╝ ╚══════╝╚═╝   ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝
      ;
      ;
      ;   To learn more about how to configure Polybar
      ;   go to https://github.com/polybar/polybar
      ;
      ;   The README contains a lot of information
      ;
      ;==========================================================

      [colors]
      background = #002F343F
      background-alt = #444
      foreground = #dfdfdf
      foreground-alt = #555
      primary = #ffb52a
      secondary = #e60053
      alert = #bd2c40

      [bar/mybar]
      width = 100%
      height = 80
      radius = 6.0
      fixed-center = false

      background = ''${colors.background}
      foreground = ''${colors.foreground}

      line-size = 3
      line-color = #f00

      border-size = 4
      border-color = #00000000

      padding-left = 0
      padding-right = 2

      module-margin-left = 1
      module-margin-right = 2

      font-0 = HaskLig:size=30;1
      font-1 = unifont:fontformat=truetype:size=70:antialias=false;0
      font-2 = siji:pixelsize=22;1
      font-3 = FontAwesome5Free:style=Regular:size=30;4
      font-4 = FontAwesome5Free:style=Solid:size=30;4
      font-5 = FontAwesome5Brands:style=Regular:size=30;4

      modules-left = ewmh xwindow
      modules-center =
      modules-right = alsa memory cpu wlan eth battery date powermenu

      tray-position = right
      tray-padding = 2

      cursor-click = pointer
      cursor-scroll = ns-resize

      [module/xwindow]
      type = internal/xwindow
      label = %title:0:30:...%

      [module/ewmh]
      type = internal/xworkspaces

      label-active = " %name% "
      label-active-foreground = #ffffff
      label-active-background = #3f3f3f
      label-active-underline = #fba922

      [module/filesystem]
      type = internal/fs
      interval = 25

      mount-0 = /

      label-mounted = %{F#0a81f5}%mountpoint%%{F-}: %percentage_used%%
      label-unmounted = %mountpoint% not mounted
      label-unmounted-foreground = ''${colors.foreground-alt}

      [module/cpu]
      type = internal/cpu
      interval = 2
      format-prefix = " "
      format-prefix-foreground = ''${colors.foreground-alt}
      format-underline = #f90000
      label = %percentage:2%%

      [module/memory]
      type = internal/memory
      interval = 2
      format-prefix = " "
      format-prefix-foreground = ''${colors.foreground-alt}
      format-underline = #4bffdc
      label = %percentage_used%%

      [module/wlan]
      type = internal/network
      interface = wlp0s20f3
      interval = 3.0

      format-connected = <ramp-signal> <label-connected>
      format-connected-underline = #9f78e1
      label-connected = %essid%

      format-disconnected =

      ramp-signal-0 = 
      ramp-signal-1 = 
      ramp-signal-2 = 
      ramp-signal-3 = 
      ramp-signal-4 = 
      ramp-signal-foreground = ''${colors.foreground-alt}

      [module/eth]
      type = internal/network
      interface = enp0s31f6
      interval = 3.0

      format-connected-underline = #55aa55
      format-connected-prefix = " "
      format-connected-prefix-foreground = ''${colors.foreground-alt}
      label-connected = %local_ip%

      format-disconnected =

      [module/date]
      type = internal/date
      interval = 5

      date = %a %b %m
      date-alt = " %Y-%m-%d"

      time = %H:%M
      time-alt = %H:%M:%S

      format-prefix-foreground = ''${colors.foreground-alt}
      format-underline = #0a6cf5

      label = %date% %time%

      [module/pulseaudio]
      type = internal/pulseaudio

      format-volume = <label-volume> <bar-volume>
      label-volume = VOL %percentage%%
      label-volume-foreground = ''${root.foreground}

      label-muted = 🔇 muted
      label-muted-foreground = #666

      bar-volume-width = 10
      bar-volume-foreground-0 = #55aa55
      bar-volume-foreground-1 = #55aa55
      bar-volume-foreground-2 = #55aa55
      bar-volume-foreground-3 = #55aa55
      bar-volume-foreground-4 = #55aa55
      bar-volume-foreground-5 = #f5a70a
      bar-volume-foreground-6 = #ff5555
      bar-volume-gradient = false
      bar-volume-indicator = |
      bar-volume-indicator-font = 2
      bar-volume-fill = ─
      bar-volume-fill-font = 2
      bar-volume-empty = ─
      bar-volume-empty-font = 2
      bar-volume-empty-foreground = ''${colors.foreground-alt}

      [module/alsa]
      type = internal/alsa

      format-volume = <label-volume> <bar-volume>
      label-volume = 
      label-volume-foreground = ''${root.foreground}

      format-muted-foreground = ''${colors.foreground-alt}
      label-muted = 

      bar-volume-width = 5
      bar-volume-foreground-0 = #55aa55
      bar-volume-foreground-1 = #55aa55
      bar-volume-foreground-2 = #55aa55
      bar-volume-foreground-3 = #55aa55
      bar-volume-foreground-4 = #55aa55
      bar-volume-foreground-5 = #f5a70a
      bar-volume-foreground-6 = #ff5555
      bar-volume-gradient = false
      bar-volume-indicator = |
      bar-volume-indicator-font = 2
      bar-volume-fill = ─
      bar-volume-fill-font = 2
      bar-volume-empty = ─
      bar-volume-empty-font = 2
      bar-volume-empty-foreground = ''${colors.foreground-alt}

      [module/battery]
      type = internal/battery
      battery = BAT0
      adapter = ADP1
      full-at = 99

      format-charging = <animation-charging> <label-charging>
      format-charging-underline = #ffb52a

      format-discharging = <animation-discharging> <label-discharging>
      format-discharging-underline = ''${self.format-charging-underline}

      format-full-prefix = 
      format-full-prefix-foreground = ''${colors.foreground-alt}
      format-full-underline = ''${self.format-charging-underline}

      ramp-capacity-0 = 
      ramp-capacity-1 = 
      ramp-capacity-2 = 
      ramp-capacity-foreground = ''${colors.foreground-alt}

      animation-charging-0 = 
      animation-charging-1 = 
      animation-charging-2 = 
      animation-charging-foreground = ''${colors.foreground-alt}
      animation-charging-framerate = 750

      animation-discharging-0 = 
      animation-discharging-1 = 
      animation-discharging-2 = 
      animation-discharging-foreground = ''${colors.foreground-alt}
      animation-discharging-framerate = 750

      [module/temperature]
      type = internal/temperature
      thermal-zone = 0
      warn-temperature = 60

      format = <ramp> <label>
      format-underline = #f50a4d
      format-warn = <ramp> <label-warn>
      format-warn-underline = ''${self.format-underline}

      label = %temperature-c%
      label-warn = %temperature-c%
      label-warn-foreground = ''${colors.secondary}

      ramp-0 = 
      ramp-1 = 
      ramp-2 = 
      ramp-foreground = ''${colors.foreground-alt}

      [module/powermenu]
      type = custom/menu

      expand-right = true

      format-spacing = 1

      label-open = 
      label-open-foreground = ''${colors.secondary}
      label-close =  cancel
      label-close-foreground = #03910c
      label-separator = |
      label-separator-foreground = ''${colors.foreground-alt}

      menu-0-0 = reboot
      menu-0-0-foreground = ''${colors.primary}
      menu-0-0-exec = sudo reboot
      menu-0-1 = shutdown
      menu-0-1-foreground = ''${colors.secondary}
      menu-0-1-exec = sudo poweroff

      [settings]
      screenchange-reload = true

      [global/wm]
      margin-top = 5
      margin-bottom = 5
    '';
  };
}