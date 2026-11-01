{ lib, config, pkgs, ... }:
lib.mkIf config.roles-config.desktop-base.enable {

  environment.systemPackages = with pkgs; [
    brave
    signal-desktop
    gum
    glow
    tokei
    rpi-imager
    thunderbird
    wireguard-tools
  ];

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

  environment.etc."brave/policies/managed/01-defaults.json".text = builtins.toJSON (import ../../programs/brave/policy.nix);
  age.secrets.brave-bitwarden-serverUrl = { # auto fill bitwarden-server url
    file = ../../secrets/brave-bitwarden-serverUrl.age;
    path = "/etc/brave/policies/managed/02-bitwarden-serverUrl.json";
    mode = "0444";
  };
}
