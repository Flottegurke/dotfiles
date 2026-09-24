{ pkgs, config, ... }:
{
  description = "Justus Dicker";
  uid = 1000;
  # the `users-<username>-password` secret is used as the user password
  extraGroups = [ "wheel" "networkmanager" "audio" "video" "docker" "libvirtd" ];
  isNormalUser = true;
  group = "users";
  shell = pkgs.bashInteractive;
}
