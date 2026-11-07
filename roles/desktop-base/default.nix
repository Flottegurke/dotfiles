{ lib, config, pkgs, ... }:
lib.mkIf config.roles-config.desktop-base.enable {

  environment.systemPackages = with pkgs; [
    signal-desktop
    gum
    glow
    tokei
    rpi-imager
    wireguard-tools
  ];
  programs.thunderbird.enable = true;
  programs-config.brave.enable = true;

  services = {
    fwupd.enable = true; # BIOS update daemon
    printing.enable = true;
    pipewire.enable = true;
    xserver.enable = true;
    libinput.enable = true;
  };

  networking.wireguard.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.ControllerMode = "dual";
    settings.General.Name = config.networking.hostName;
  };

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

}
