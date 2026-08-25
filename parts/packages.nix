{ ... }:
{
  perSystem = { pkgs, ... }: # for each system, run this function with the system specific arguments
  let
    mkPackage = name: pkgs.callPackage ../pkgs/${name} {}; # provide dependencies for <name> package
    pkgNames = builtins.attrNames (pkgs.lib.filterAttrs (_: type: type == "directory") (builtins.readDir ../pkgs)); # contains name of every directory in `../pkgs`
  in
  {
    packages = pkgs.lib.genAttrs pkgNames mkPackage; # autodiscover every custom module and provide their dependencies
  };
}



