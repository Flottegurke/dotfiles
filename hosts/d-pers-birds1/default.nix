# config for the old thinkpad with the birds stickers
{ ... }:
{
  networking.hostName = "d-pers-birds1";

  nixpkgs.hostPlatform = "x86_64-linux";

  users-config.testuser.enable = true;

  roles-config.laptop.enable = true;
  roles-config.desktop-kde.enable = true;
}
