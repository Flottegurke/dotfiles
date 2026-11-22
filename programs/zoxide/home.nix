{ lib, osConfig, ... }:
{
  programs.zoxide = lib.mkIf osConfig.programs-config.zoxide.enable {
    enable = true;

    enableZshIntegration = false;
  };
}
