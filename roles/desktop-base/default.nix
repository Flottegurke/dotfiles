{ lib, config, pkgs, ... }:
lib.mkIf config.roles-config.desktop-base.enable {

  environment.systemPackages = with pkgs; [
    brave
    signal-desktop
    gum
    glow
    tokei
    rpi-imager
    wireguard-tools
  ];

  services = {
    fwupd.enable = true; # BIOS update daemon
    printing.enable = true;
    pipewire.enable = true;
    xserver.enable = true;
    libinput.enable = true;
  };

  networking.wireguard.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.ControllerMode = "dual";
    settings.General.Name = config.networking.hostName;
  };

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  environment.etc."brave/policies/managed/01-defaults.json".text = builtins.toJSON (import ../../programs/brave/policy.nix);
  age.secrets.brave-bitwarden-serverUrl = { # auto fill bitwarden-server url
    file = ../../secrets/brave-bitwarden-serverUrl.age;
    path = "/etc/brave/policies/managed/02-bitwarden-serverUrl.json";
    mode = "0444";
  };

  programs.thunderbird = {
    enable = true;
    package = pkgs.thunderbird;
    policies = {
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
  };
  age.secrets."users-flottegurke-thunderbird-account" = lib.mkIf config.programs.thunderbird.enable {
    file = ../../secrets/users-flottegurke-thunderbird-account.age;
    owner = "flottegurke";
    group = "users";
    mode = "0400";
 };
}
