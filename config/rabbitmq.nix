{
  services.rabbitmq = {
    enable = true;
    listenAddress = "127.0.0.1";
    port = 5672;
    dataDir = "/var/lib/rabbitmq";
  };
}
