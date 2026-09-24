{ lib, config, ... }:
lib.mkIf config.roles-config.virt-manager-vm.enable {
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  hardware.bluetooth.enable = lib.mkForce false;
  services.fwupd.enable = lib.mkForce false;
  services.power-profiles-daemon.enable = lib.mkForce false;
  powerManagement.enable = lib.mkForce false;
}
