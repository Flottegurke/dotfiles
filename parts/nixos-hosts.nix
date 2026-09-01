{ inputs, ... }:
let
  mkHost = name: inputs.nixpkgs.lib.nixosSystem { # construct a NixOS system for <name>
    modules = [
      ../hosts/${name}
      ../hosts/${name}/hardware-configuration.nix
      ../common
      inputs.home-manager.nixosModules.default # add home manager module (integrated version)
      inputs.agenix.nixosModules.default # add agenix module
    ];
    specialArgs = { inherit inputs; }; # make the flake's `inputs` avaiable to the NixOS modules
  };

  hostNames = builtins.attrNames (inputs.nixpkgs.lib.filterAttrs (_: type: type == "directory") (builtins.readDir ../hosts)); # contains name of every directory in `../hosts`
in
{
  flake.nixosConfigurations = inputs.nixpkgs.lib.genAttrs hostNames mkHost; # expose every NixOS system as a flake output (by calling `mkHost` with the `hostNames` attrset)
}
