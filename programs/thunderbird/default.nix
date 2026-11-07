{ lib, config, ... }:
{
  programs.thunderbird.policies = lib.mkIf config.programs.thunderbird.enable {

    DisableTelemetry = true;
    NetworkPrediction = false;
    DisablePasswordReveal = true;
    SSLVersionMin = "tls1.2";
    DisableSecurityBypass = {
      InvalidCertificate = true;
      SafeBrowsing = true;
    };
    OfferToSaveLoginsDefault = true;
    ExtensionUpdate = true;
    Proxy = {
      Mode = "system";
      Locked = false;
    };

    SearchEngines = {
      Add = [
        {
          Name = "Brave Search";
          Alias = "br";
          URLTemplate = "https://search.brave.com/search?q={searchTerms}";
        }
      ];
      Default = "Brave Search";
    };

  # ExtensionSettings = {
  #   "extension-id@example.org" = {
  #     installation_mode = "force_installed";
  #     install_url = "https://example.org/extension.xpi";
  #   };
  # };
    RequestedLocales = [
      "en-US"
      "de"
    ];
  };

  age.secrets."users-flottegurke-thunderbird-account" = lib.mkIf config.programs.thunderbird.enable {
    file = ../../secrets/users-flottegurke-thunderbird-account.age;
    owner = "flottegurke";
    group = "users";
    mode = "0400";
  };
}
