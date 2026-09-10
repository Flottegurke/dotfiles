{ lib, config, pkgs, ... }:
lib.mkIf config.roles-config.laptop.enable {

  roles-config.desktop-base.enable = true;

  networking.wireless.enable = true;

  powerManagement.enable = true;
  services.power-profiles-daemon.enable = true;

  services.libinput.touchpad.tapping = true;
}


