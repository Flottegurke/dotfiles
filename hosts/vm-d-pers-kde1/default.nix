{
  meta = {
    isDesktop = true;
    isWork = false;
    isAdmin = false;
  };

  module = { ... }:
  {
    networking.hostName = "vm-d-pers-kde1";
    nixpkgs.hostPlatform = "x86_64-linux";

    imports = [ ./disko.nix ];

    roles-config.desktop-kde.enable = true;
    roles-config.virt-manager-vm.enable = true;

   swapSizeMB = 4000;
  };
}
