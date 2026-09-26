{
  meta = {
    isDesktop = true;
    isWork = true;
    isAdmin = true;
  };

  module = { ... }:
  {
    networking.hostName = "dp-greene1";
    nixpkgs.hostPlatform = "x86_64-linux";

    roles-config.desktop-kde.enable = true;
    roles-config.laptop.enable = true;


  };
}
