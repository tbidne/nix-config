{
  home.file = {
    ".config/navi/config.toml".text = ''
      poll-interval = 10

      [logging]
      severity = "debug"

      [battery-status]
      timeout = "5"

      [battery-percentage]

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
      device = "wlp0s20f3"

      [[net-interface]]
      device = "enp0s31f6"
    '';
  };
}
