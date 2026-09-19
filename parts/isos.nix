{ inputs, ... }:
let
  keys = import ../secrets/keys.nix { lib = inputs.nixpkgs.lib; };
in
{
  flake.nixosConfigurations.installer-iso = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
      {
        console.keyMap = "de-latin1-nodeadkeys";

        services.openssh.enable = true;
        services.openssh.settings.PasswordAuthentication = false;
        services.openssh.settings.PermitRootLogin = "prohibit-password";

        users.users.root.openssh.authorizedKeys.keys = keys.allAdminMachines;

        environment.systemPackages = [ inputs.disko.packages.x86_64-linux.disko ];
      }
    ];
  };
}
