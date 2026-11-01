{ lib, ... }:
let
  programNames = builtins.attrNames (lib.filterAttrs (name: type: type == "directory" && builtins.pathExists (./${name}/default.nix))
    (builtins.readDir ./.)); # contains every program directory with a default.nix
in
{
  imports = map (name: ./${name}) programNames; # import every discovered program configuration
}
