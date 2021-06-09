{
  home.file = {
    ".xmobarrc".text = ''
      Config {
        -- Appearance
          font = "xft:hasklig:size=9:antialias=true"
        , bgColor = "#282828"
        , fgColor = "#ebdbb2"
        -- , position = TopW L 93   -- Leave space for Trayer
        , position = TopW L 100

        -- Layout
        , sepChar = "%"     -- delineator between plugin names and straight text
        , alignSep = "}{"   -- separator between left-right alignment
        , template = "%StdinReader% } { %KDCA% | %cpu% | %memory% | %swap% | %dynnetwork% | %battery% | %date%"

        -- Behaviour
        , lowerOnStart = False       -- send to bottom of window stack on start
        , pickBroadest = False       -- choose widest display (multi-monitor)
        , overrideRedirect = False   -- set the Override Redirect flag (Xlib)

        --Plugins
        , commands =
            -- CPU Activity Monitor
            [ Run Cpu            [ "--template" , "CPU: <total>%"
                                , "--Low"      , "30"         -- units: %
                                , "--High"     , "70"         -- units: %
                                , "--low"      , "#b8bb26"
                                , "--normal"   , "#ebdbb2"
                                , "--high"     , "#fb4934"
                                ] 10

            -- Memory Usage Monitor
            , Run Memory         [ "--template" , "MEM <usedratio>%"
                                , "--Low"      , "20"        -- units: %
                                , "--High"     , "90"        -- units: %
                                , "--low"      , "#b8bb26"
                                , "--normal"   , "#ebdbb2"
                                , "--high"     , "#fb4934"
                                ] 10

            -- Battery Monitor
            , Run BatteryP ["BAT0"]        [ "--template" , "BAT: <acstatus>"
                                , "--Low"      , "10"        -- units: %
                                , "--High"     , "80"        -- units: %
                                , "--low"      , "#fb4934"
                                , "--normal"   , "#ebdbb2"
                                , "--high"     , "#b8bb26"

                                , "--" -- battery specific options
                                          -- discharging status
                                          , "-o"   , "<left>% (<timeleft>)"
                                          -- AC "on" status
                                          , "-O" , "<fc=#b8bb26>Charging</fc>"
                                          -- charged status
                                          , "-i"   , "<fc=#b8bb26>Charged</fc>"
                                ] 50

            -- Read from STDIN
            , Run StdinReader

            -- Display the current Wireless SSID
            -- , Run Wireless "wlp0s20f3" [ "-t", "<essid>" ] 10

            -- Weather Monitor
            , Run Weather "KDCA" [ "--template" , " <skyCondition>  <tempC>C  <rh>%  <pressure> hPa"
                                , "--Low"      , "10"
                                , "--High"     , "35"
                                , "--low"      , "#b8bb26"
                                , "--normal"   , "#ebdbb2"
                                , "--high"     , "#fb4934"
                                ] 36000

            -- Time and Date Display
            , Run Date           "<fc=#b8bb26>%a %b %_d %H:%M</fc>" "date" 10
            , Run Swap [] 10
            , Run DynNetwork [ "--template" , "<dev>: <tx>kB/s"
                , "--Low"      , "50000"   -- units: B/s
                , "--High"     , "500000"   -- units: B/s
                , "--low"      , "#b8bb26"
                , "--normal"   , "#ebdbb2"
                , "--high"     , "fb4934"
                ] 10
          ]
      }
    '';
  };
}
