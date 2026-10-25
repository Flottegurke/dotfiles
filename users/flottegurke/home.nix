{ config, pkgs, lib, osConfig, ... }:

{

  home.packages = with pkgs; [
  ] ++ lib.optionals osConfig.roles-config.desktop-kde.enable [
    (pkgs.catppuccin-kde.override { flavour = [ "mocha" ]; accents = [ "sapphire" ]; })
  ];

  home.file = {
  };

  # general
  programs.git = {
    enable = true;
    userName = "Justus Dicker";
    userEmail = "justus.dicker@confettico.de";
  };

  programs.ssh = {
    enable = true;

    matchBlocks."github.com" = {
      hostname = "ssh.github.com";
      user = "git";
      port = 443;
    };
  };


  # dektop-kde
  programs.plasma = lib.mkIf osConfig.roles-config.desktop-kde.enable {
    enable = true;
    workspace = {
      wallpaper = ./wallpaper.png;
      colorScheme = "CatppuccinMochaSapphire";
      theme = "breeze-dark";
    };
    panels = [
      {
        location = "bottom";
        widgets = [
          "org.kde.plasma.kickoff"
          "org.kde.plasma.icontasks"
          "org.kde.plasma.systemtray"
          "org.kde.plasma.digitalclock"
        ];
      }
    ];
    input.touchpads = [
      {
        name = "ELAN0710:01 04F3:30ED Touchpad";
        vendorId = "04f3";
        productId = "30ED";
        naturalScroll = true;
        scrollSpeed = 0.25;
      }
      {
        name = "ETPS/2 Elantech Touchpad";
        vendorId = "0002";
        productId = "000e";
        naturalScroll = true;
        scrollSpeed = 0.25;
      }
    ];
  };


  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  home.stateVersion = "26.05"; # DO NOT CENTRALISE / CHANGE
}
