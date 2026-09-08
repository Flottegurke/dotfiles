{ lib, ... }:
let
  serviceNames = builtins.attrNames ( lib.filterAttrs (name: type: type == "directory") (builtins.readDir ./.)); # every service config in this directory
in
{
  imports = map (name: ./${name}) serviceNames; # import every discovered service
}
