{ lib, config, pkgs, ... }:
{
  options.programs-config.brave.enable =
    lib.mkEnableOption "Brave browser";

  config = lib.mkIf config.programs-config.brave.enable {

    environment.systemPackages = [ pkgs.brave ];

    environment.etc."brave/policies/managed/01-defaults.json".text = builtins.toJSON (import ./policy.nix);

    age.secrets.brave-bitwarden-serverUrl = {
      file = ../../secrets/brave-bitwarden-serverUrl.age;
      path = "/etc/brave/policies/managed/02-bitwarden-serverUrl.json";
      mode = "0444";
    };

  };
}
