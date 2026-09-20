{ pkgs, config, ... }:
{
  description = "graf";
  # The `users-graf-password` secret is used as the user password.
  isNormalUser = true;
  group = "users";
  shell = pkgs.bashInteractive;
  extraGroups = [ "wheel" "networkmanager" "audio" "video" "docker" "libvirtd"  ];
}
