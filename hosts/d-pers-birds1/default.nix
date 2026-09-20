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

    users-config.graf.enable = true;

    roles-config.laptop.enable = true;
    roles-config.desktop-kde.enable = true;
  };
}
