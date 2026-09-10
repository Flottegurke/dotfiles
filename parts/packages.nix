{ inputs, ... }:
{
  perSystem = { pkgs, system, ... }: # for each system, run this function with the system specific arguments
  let
    pkgNames = builtins.attrNames (pkgs.lib.filterAttrs (_: type: type == "directory") (builtins.readDir ../pkgs)); # contains name of every directory in `../pkgs`
    mkPackage = name:
      let
        fn = import ../pkgs/${name};
        wantsAgenix = pkgs.lib.hasAttr "agenix" (builtins.functionArgs fn);
        extraArgs = pkgs.lib.optionalAttrs wantsAgenix {
          agenix = inputs.agenix.packages.${system}.default;
        };
      in
      pkgs.callPackage ../pkgs/${name} extraArgs; # provide dependencies for <name> package
  in
  {
    packages = pkgs.lib.genAttrs pkgNames mkPackage; # autodiscover every custom module and provide their dependencies
  };
}
