{ lib, osConfig, ... }:
{
  programs.kitty = lib.mkIf osConfig.programs-config.kitty.enable {
    enable = true;

    settings = {
      scrollback_lines = 10000;
      enable_audio_bell = false;
    };
  };
}
