{ lib, pkgs, osConfig, ... }:
lib.mkIf (lib.elem pkgs.rpi-imager osConfig.environment.systemPackages) {
  xdg.desktopEntries."com.raspberrypi.rpi-imager" = {
    name = "Raspberry Pi Imager";
    genericName = "SD Card Imager";
    comment = "Write operating system images to SD cards";

    icon = "rpi-imager";
    categories = [ "Utility" ];

    exec = "${pkgs.kdePackages.konsole}/bin/konsole -e /run/wrappers/bin/sudo /run/current-system/sw/bin/rpi-imager";

    terminal = false;
    startupNotify = false;
  };
}
