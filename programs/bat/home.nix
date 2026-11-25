{ pkgs, lib, osConfig, ... }:
{
  programs.bat = lib.mkIf osConfig.programs-config.bat.enable {
    enable = true;

    extraPackages = with pkgs.bat-extras; [
      batgrep
      batdiff
      batman
      batwatch
    ];

    themes."Catppuccin Mocha" = {
      src = ./themes;
      file = "Catppuccin Mocha.tmTheme";
    };

    config = {
      theme = "Catppuccin Mocha";
      style = "numbers,changes,header,grid,snip";
      paging = "auto";
      wrap = "never";
      tabs = "4";
    };
  };
}
