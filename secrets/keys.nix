{ lib }:
let
  hostNames = builtins.attrNames (lib.filterAttrs (name: type: type == "directory") (builtins.readDir ../hosts));
  keyStrings = import ./keys-data.nix;
  meta = name: (import ../hosts/${name}).meta;

  entries = lib.genAttrs hostNames (name: (meta name) // { key = keyStrings.${name} or null; });
  withKeys = lib.filterAttrs (_: v: v.key != null) entries;
in
{
  inherit entries;
  allMachines = lib.mapAttrsToList (_: v: v.key) withKeys;
  allDesktops = lib.mapAttrsToList (_: v: v.key) (lib.filterAttrs (_: v: v.isDesktop) withKeys);
  allWorkMachines = lib.mapAttrsToList (_: v: v.key) (lib.filterAttrs (_: v: v.isWork) withKeys);
  allAdminMachines = lib.mapAttrsToList (_: v: v.key) (lib.filterAttrs (_: v: v.isAdmin) withKeys);
}
