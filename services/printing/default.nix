{ lib, config, ... }:
lib.mkIf config.services.printing.enable {
  services = {
    printing = {
      stateless = false;
      openFirewall = false;
      browsed.enable = true;
    };

    avahi = {
      nssmdns4 = true;
      nssmdns6 = true;
      openFirewall = true;
    };
  };
}
