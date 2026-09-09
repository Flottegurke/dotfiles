{ lib, config, ... }:
lib.mkIf config.services.pipewire.enable {
  services.pulseaudio.enable = false;
  services.pipewire = {
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
    raopOpenFirewall = true;
  };

  hardware.alsa.enablePersistence = true;

  security.rtkit.enable = true;
}
