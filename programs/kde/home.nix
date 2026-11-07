{ lib, pkgs, osConfig, ... }:
lib.mkIf osConfig.services.desktopManager.plasma6.enable {
  home.packages = [
    (pkgs.catppuccin-kde.override { flavour = [ "mocha" ]; accents = [ "sapphire" ]; })
  ];

  programs.plasma = {
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

    input.touchpads = [ # every touchpad is configured seperately becaue defaults are not supported
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
}


