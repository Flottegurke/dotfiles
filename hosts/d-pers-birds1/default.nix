{
  meta = {
    isDesktop = true;
    isWork = false;
    isAdmin = true;
  };

  module = { ... }:
  {
    networking.hostName = "d-pers-birds1";

    nixpkgs.hostPlatform = "x86_64-linux";

    users-config.testuser.enable = true;
    users-config.rescue.enable = true;

    roles-config.laptop.enable = true;
    roles-config.desktop-kde.enable = true;
  };
}
