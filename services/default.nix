{ lib, ... }:
let
  serviceFiles = builtins.attrNames ( lib.filterAttrs (name: type: type == "regular" && name != "default.nix" && builtins.match ".*\\.nix" name != null) (builtins.readDir ./.)); # every service file in this directory
in
{
  imports = map (name: ./${name}) serviceFiles; # import every discovered service
}
