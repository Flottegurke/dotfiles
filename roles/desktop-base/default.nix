{ lib, config, pkgs, ... }:
lib.mkIf config.roles-config.desktop-base.enable {

  environment.systemPackages = with pkgs; [
    brave
    signal-desktop
    gum
    glow
    tokei
    rpi-imager
    thunderbird
  ];

  services = {
    fwupd.enable = true; # BIOS update daemon
    printing.enable = true;
    pipewire.enable = true;
    xserver.enable = true;
    libinput.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.ControllerMode = "dual";
    settings.General.Name = config.networking.hostName;
  };


  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  environment.etc."brave/policies/managed/01-defaults.json".text = builtins.toJSON {
    # privacy & unnessesary features
    BraveRewardsDisabled = true;
    BraveWalletDisabled = true;
    BraveVPNDisabled = true;
    BraveAIChatEnabled = true;
    BraveNewsDisabled = true;
    BraveTalkDisabled = true;
    BravePlaylistEnabled = false;
    BraveSpeedreaderEnabled = true;
    BraveWaybackMachineEnabled = true;
    BraveP3AEnabled = false;
    BraveStatsPingEnabled = false;
    BraveWebDiscoveryEnabled = false;
    MetricsReportingEnabled = false;
    SafeBrowsingProtectionLevel = 1;
    DnsOverHttpsMode = "automatic";
    PasswordManagerEnabled = false;
    AutoFillEnabled = false;
    AutofillAddressEnabled = false;
    AutofillCreditCardEnabled = false;
    WebRtcIPHandling = "default_public_interface_only";
    DefaultAutomaticDownloadsSetting = 3;
    DefaultGeolocationSetting = 3;
    DefaultNotificationsSetting = 3;
    DefaultWebBluetoothGuardSetting = 3;
    DefaultFileSystemReadGuardSetting = 2;
    DefaultFileSystemWriteGuardSetting = 2;
    DefaultClipboardSetting = 2;
    DefaultSerialGuardSetting = 2;
    DefaultWebHidGuardSetting = 2;

    # general
    DefaultDownloadDirectory = "/home/flottegurke/Downloads";
    PromptForDownloadLocation = false;
    TranslateEnabled = true;
    RestoreOnStartup = 1;
    BackgroundModeEnabled = false;
    PrintingEnabled = true;
    AlwaysOpenPdfExternally = true;

    # search
    DefaultSearchProviderEnabled = true;
    DefaultSearchProviderName = "Brave Search";
    DefaultSearchProviderKeyword = "br";
    DefaultSearchProviderSearchURL = "https://search.brave.com/search?q={searchTerms}";
    DefaultSearchProviderSuggestURL = "https://search.brave.com/api/suggest?q={searchTerms}";
    SiteSearchSettings = [
      {
        name = "NixOS Packages";
        shortcut = "nixpg";
        url = "https://search.nixos.org/packages?query={searchTerms}";
      }

      {
        name = "NixOS Options";
        shortcut = "nixop";
        url = "https://search.nixos.org/options?query={searchTerms}";
      }

      {
        name = "Home Manager Options";
        shortcut = "hmop";
        url = "https://home-manager-options.extranix.com/?query={searchTerms}";
      }

      {
        name = "GitHub";
        shortcut = "gh";
        url = "https://github.com/search?q={searchTerms}";
      }

      {
        name = "Wikipedia";
        shortcut = "wiki";
        url = "https://en.wikipedia.org/wiki/Special:Search?search={searchTerms}";
      }
    ];

    # extenshions
    ExtensionSettings = {
      "*" = {installation_mode = "blocked";};
      "bkkmolkhemgaeaeggcmfbghljjjoofoh" = {installation_mode = "force_installed"; update_url = "https://clients2.google.com/service/update2/crx"; }; # Catppuccin Chrome Theme - Mocha
      "lnjaiaapbakfhlbjenjkhffcdpoompki" = {installation_mode = "force_installed"; update_url = "https://clients2.google.com/service/update2/crx"; }; # Catppuccin for Web File Explorer Icons
      "clngdbkpkpeebahjckkjfobafhncgmne" = {installation_mode = "force_installed"; update_url = "https://clients2.google.com/service/update2/crx"; toolbar_pin = "force_pinned"; }; # Stylus
      "nngceckbapebfimnlniiiahkandclblb" = {installation_mode = "force_installed"; update_url = "https://clients2.google.com/service/update2/crx"; toolbar_pin = "force_pinned"; }; # Bitwarden Password Manager
      "aicmkgpgakddgnaphhhpliifpcfhicfo" = {installation_mode = "force_installed"; update_url = "https://clients2.google.com/service/update2/crx"; toolbar_pin = "force_pinned"; }; # Postman Interceptor
      "kmfcinojnfabkpndlgomnfjllgeppegb" = {installation_mode = "force_installed"; update_url = "https://clients2.google.com/service/update2/crx"; }; # Youtube Custom Speed
      "mnjggcdmjocbbbhaepdhchncahnbgone" = {installation_mode = "force_installed"; update_url = "https://clients2.google.com/service/update2/crx"; }; # SponsorBlock for YouTube - Skip Sponsorships
      "khncfooichmfjbepaaaebmommgaepoid" = {installation_mode = "force_installed"; update_url = "https://clients2.google.com/service/update2/crx"; }; # Unhook - Remove YouTube Recommended & Shorts
    };
  };
  age.secrets.brave-bitwarden-serverUrl = { # auto fill bitwarden-server url
    file = ../../secrets/brave-bitwarden-serverUrl.age;
    path = "/etc/brave/policies/managed/02-bitwarden-serverUrl.json";
    mode = "0444";
  };
}
