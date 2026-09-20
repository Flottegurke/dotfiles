{ config, pkgs, inputs, ... }:

{
  imports = [
      ../users
      ../roles
      ../services
      ../modules/nixos
      ./home.nix
      inputs.home-manager.nixosModules.default
      inputs.agenix.nixosModules.default
      inputs.disko.nixosModules.default
    ];
  nixpkgs.overlays = [ (import ../overlays) ];

  time.timeZone = "Europe/Berlin";
  time.hardwareClockInLocalTime = false;
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_CTYPE = "de_DE.UTF-8"; # decimal / thousands seperators conventions
    LC_NUMERIC = "de_DE.UTF-8"; # decimal / thousands seperators conventions
    LC_TIME = "de_DE.UTF-8";
    LC_COLLATE = "de_DE.UTF-8"; # how characters/strings are sorted (special characters at end vs. after normal version of character)
    LC_MONETARY = "de_DE.UTF-8";
    LC_MESSAGES = "en_US.UTF-8";

    LC_PAPER = "de_DE.UTF-8"; # default paper format (eg. A4)
    LC_NAME = "de_DE.UTF-8";
    LC_ADDRESS = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8"; # default telephone number format
    LC_MEASUREMENT = "de_DE.UTF-8";
  };

  networking = {
    enableIPv6 = true;
    firewall.enable = true;
    firewall.logRefusedConnections = true;
    networkmanager.enable = true;
  };

  users.mutableUsers = false;
  users-config.flottegurke.enable = true; # enable default user on every host
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  console.keyMap = "de-latin1-nodeadkeys";
  age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];


  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    useOSProber = true;
    theme = inputs.self.packages.${pkgs.system}.modern-grub-theme;
  };

  environment.systemPackages = with pkgs; [
    curl
    wget
    git
    vim
    lazygit
    rsync
    ripgrep
    inputs.agenix.packages.${pkgs.system}.default
    inputs.self.packages.${pkgs.system}.config-new-user
    inputs.self.packages.${pkgs.system}.config-new-host
  ];

  system.stateVersion = "26.05"; # Read docs before changing: man configuration.nix or https://nixos.org/nixos/options.html).
}
