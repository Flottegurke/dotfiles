{ lib, config, ... }:
{
  age.secrets."users-flottegurke-git-identity" = lib.mkIf config.users-config.flottegurke.enable {
    file = ../../secrets/users-flottegurke-git-identity.age;
    owner = "flottegurke";
    group = "users";
    mode = "0400";
  };

  age.secrets."users-flottegurke-thunderbird-account" = lib.mkIf (config.users-config.flottegurke.enable && config.programs.thunderbird.enable) {
    file = ../../secrets/users-flottegurke-thunderbird-account.age;
    owner = "flottegurke";
    group = "users";
    mode = "0400";
  };
}
