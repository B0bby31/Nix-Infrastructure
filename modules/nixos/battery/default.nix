{ self, inputs, ... }: {
  flake.modules.nixos.battery = { lib, ... }: {
    services.upower = {
      enable = true;
      # Don't know if asahi supports this, we will see
      noPollBatteries = true;
    };
  };
}
