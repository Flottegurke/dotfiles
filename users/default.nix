{ lib, pkgs, config, ... }:
let
  userNames = builtins.attrNames (lib.filterAttrs (name: type: type == "directory") (builtins.readDir ./.)); # usernames derived from directory names
  userData = lib.genAttrs userNames (name: import ./${name} { inherit pkgs config; }); # import each data file, keyed by username
  enabledUsers = lib.filterAttrs (name: _: config.users-config.${name}.enable) userData; # contains only enabled users

  homeConfigPath = name: ./${name}/home.nix;
  hasHomeConfig = name: builtins.pathExists (homeConfigPath name);
in
{
  options.users-config = lib.genAttrs userNames (name: {
    enable = lib.mkEnableOption "enable user: ${name}";
  }); # generate enable option for every user

  config.users.users = lib.mapAttrs # build NixOS user config for enabled users
    (name: data: lib.recursiveUpdate data {
      hashedPasswordFile = config.age.secrets."users-${name}-password".path;
    })
    enabledUsers;

  config.age.secrets = lib.mapAttrs' # decrypt user-password secrets for enabled users
    (name: _: lib.nameValuePair "users-${name}-password" {
      file = ../secrets/users-${name}-password.age;
    })
    enabledUsers;

  config.home-manager.users = lib.mapAttrs # wire each enabled users home-manager config
    (name: _: if hasHomeConfig name then import (homeConfigPath name) else { })
    enabledUsers;
}
