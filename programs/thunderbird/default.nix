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

    ExtensionUpdate = true;
    ExtensionSettings = {
      "de-DE@dictionaries.addons.mozilla.org" = {
        installation_mode = "force_installed";
        install_url = "https://addons.thunderbird.net/thunderbird/downloads/latest/dictionary-german/addon-3077-latest.xpi";
      };
      "cloud@johannes-endres.de" = {
        installation_mode = "force_installed";
        install_url = "https://addons.thunderbird.net/thunderbird/downloads/latest/filelink-nextcloud-owncloud/addon-987761-latest.xpi";
      };
      "mailmindr@arndissler.net" = {
        installation_mode = "force_installed";
        install_url = "https://addons.thunderbird.net/thunderbird/downloads/latest/mailmindr/addon-46207-latest.xpi";
      };
      "{049b80ff-2e7d-5d53-8090-d8b53a95f1f6}" = {
#      "{f6d05f0c-39a8-5c4d-96dd-4852202a8244}" = {
        installation_mode = "force_installed";
        install_url = "file://${./themes/mocha-sapphire.xpi}";
      };

    };



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
