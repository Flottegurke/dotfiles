{ lib, pkgs, osConfig, ... }:
{
  programs.btop = lib.mkIf (lib.elem pkgs.btop osConfig.environment.systemPackages) {
    enable = true;
    package = null; # Already installed by NixOS

    themes.catppuccin_mocha = ./themes/catppuccin_mocha.theme;

    settings = {
      color_theme = "catppuccin_mocha";
      theme_background = true;
      truecolor = true;


      update_ms = 1000;
      vim_keys = true;
      shown_boxes = "cpu mem net proc gpu0 gpu1";
      show_battery = true;
    };
  };
}
