{ inputs, ... }:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
#  home-manager.backupFileExtension = "backup"; # rename already existing config, instead of throwong an error TODO: enable if errors due to auto generated configs become unberable
  home-manager.extraSpecialArgs = { inherit inputs; };
  home-manager.sharedModules = [
    ../modules/home-manager { programs.home-manager.enable = true; }
    inputs.plasma-manager.homeManagerModules.plasma-manager
  ];
}
