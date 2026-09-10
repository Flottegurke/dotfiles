{ lib, config, pkgs, ... }:
lib.mkIf config.roles-config.desktop-kde.enable {
  roles-config.desktop-base.enable = true;

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  services.desktopManager.plasma6.enable = true;
  services.desktopManager.plasma6.enableQt5Integration = true;
services.displayManager.defaultSession = "plasma";
}
