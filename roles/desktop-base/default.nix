{ lib, config, pkgs, ... }:
lib.mkIf config.roles-config.desktop-base.enable {

  environment.systemPackages = with pkgs; [
    brave
    signal-desktop
    gum
    glow
  ];

  services = {
    fwupd.enable = true; # BIOS update daemon
    printing.enable = true;
    pipewire.enable = true;
    xserver.enable = true;
    libinput.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.ControllerMode = "dual";
    settings.General.Name = config.networking.hostName;
  };
}
