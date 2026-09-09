{ lib, config, ... }:
lib.mkIf config.services.xserver.enable {
  services.xserver.xkb = {
    layout = "de";
    variant = "nodeadkeys";
  };
}
