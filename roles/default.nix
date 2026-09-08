{ lib, config, ... }:
let
  roleNames = builtins.attrNames (lib.filterAttrs (name: type: type == "directory") (builtins.readDir ./.)); # contains all nixos modules(roles) in this directory
in
{
  options.roles-config = lib.genAttrs roleNames (name: {
    enable = lib.mkEnableOption "role: ${name}";
  });

  imports = map (name: ./${name}) roleNames;

#  config.assertions = [
#    {
#      assertion = !(config.roles-config.desktop-hypland.enable && config.roles-config.desktop-kde.enable);
#      message = "roles: desktop-hyprland and desktop-kde are mutually exclusive - only one is allowed to be enabled.";
#    }
#  ];
}
