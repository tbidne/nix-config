{
  home.file = {
    ".config/navi/navi-config.toml".text = ''
      [logging]
      severity = "debug"

      [battery-status]
      poll-interval = "30"
      timeout = "5"

      [battery-percentage]
      poll-interval = "30"

      [[battery-percentage.alert]]
      percent = 50

      [[battery-percentage.alert]]
      percent = 30

      [[battery-percentage.alert]]
      percent = 20
      urgency = "critical"

      [[battery-percentage.alert]]
      percent = 10
      urgency = "critical"

      [[battery-percentage.alert]]
      percent = 5
      urgency = "critical"

      [[net-interface]]
      poll-interval = "30"
      device = "wlp0s20f3"

      [[net-interface]]
      poll-interval = "30"
      device = "enp0s31f6"
    '';
  };
}
