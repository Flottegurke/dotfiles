{ lib, ... }:
{
  options.programs-config.zoxide.enable = lib.mkEnableOption "zoxide directory navigation";
}
