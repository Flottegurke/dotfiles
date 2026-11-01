{ config, lib, osConfig, ... }:
let
  thunderbirdEnabled = osConfig.programs.thunderbird.enable;
in
{
  programs.git.settings.include.path = osConfig.age.secrets."users-flottegurke-git-identity".path;

  home.file.".thunderbird/default/user.js".force = thunderbirdEnabled;
  home.activation.privateThunderbirdAccount = lib.mkIf thunderbirdEnabled (
    lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      secret=${lib.escapeShellArg osConfig.age.secrets."users-flottegurke-thunderbird-account".path}
      profile=${lib.escapeShellArg "${config.home.homeDirectory}/.thunderbird/default"}

      if [ ! -r "$secret" ]; then
        echo "Thunderbird account secret is unavailable: $secret" >&2
        exit 1
      fi

      if [ ! -f "$profile/user.js" ]; then
        echo "Thunderbird default profile user.js was not generated." >&2
        exit 1
      fi

      umask 077
      tmp="$(mktemp "$profile/.user.js.XXXXXXXX")"

      {
        cat "$profile/user.js"
        printf '\n'
        cat "$secret"
      } > "$tmp"

      chmod 0600 "$tmp"
      mv -f "$tmp" "$profile/user.js"
    ''
  );

  home.stateVersion = "26.05"; # DO NOT CENTRALISE / CHANGE
}
