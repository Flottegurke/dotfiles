{ lib, ... }:
let
  moduleFiles = builtins.attrNames (lib.filterAttrs (name: type: type == "regular" && name != "default.nix" && builtins.match ".*\\.nix" name != null) (builtins.readDir ./.)); # contains every module file in this directory
in
{
  imports = map (name: ./${name}) moduleFiles; # import every discovered module
}

