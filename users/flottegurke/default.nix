{ pkgs, config, ... }:
{
  description = "Justus Dicker";
  # the `users-<username>-password` secret is used as the user password
  extraGroups = [ "wheel" "networkmanager" "audio" "video" "docker" ];
  isNormalUser = true;
  group = "users";
  shell = pkgs.bashInteractive;
}
