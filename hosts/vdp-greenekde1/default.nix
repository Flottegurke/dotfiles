{
  meta = {
    isDesktop = true;
    isWork = true;
    isAdmin = true;
  };

  module = { ... }:
  {
    networking.hostName = "vdp-greenekde1";
    nixpkgs.hostPlatform = "x86_64-linux";


    roles-config.desktop-kde.enable = true;
    roles-config.virt-manager-vm.enable = true;

   swapSizeMB = 400;
  };
}
