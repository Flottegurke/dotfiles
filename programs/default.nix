{ lib, ... }:
let
  programNames = builtins.attrNames (lib.filterAttrs (name: type: type == "directory" && builtins.pathExists (./${name}/default.nix)) (builtins.readDir ./.)); # every program providing a NixOS module
in
{
  imports = map (name: ./${name}/default.nix) programNames;
}
