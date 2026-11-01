let
  keys = import ./keys.nix { lib = (import <nixpkgs> {}).lib; };
in
{
  "brave-bitwarden-serverUrl.age".publicKeys = keys.allDesktops;
  "users-flottegurke-git-identity.age".publicKeys = keys.allMachines;
  "users-flottegurke-thunderbird-account.age".publicKeys = keys.allDesktops;

  # Auto appended by `config-new-user`.
  "users-flottegurke-password.age".publicKeys = keys.allMachines;
  "users-graf-password.age".publicKeys = keys.allMachines;
}
