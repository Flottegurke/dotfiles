{ lib, ... }:
let
  programNames = builtins.attrNames (lib.filterAttrs (name: type: type == "directory" && builtins.pathExists (./${name}/home.nix)) (builtins.readDir ./.)); # every program providing a Home Manager module
in
{
  imports = map (name: ./${name}/home.nix) programNames;
}
