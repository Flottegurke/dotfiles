{ lib, ... }:
{
  options.programs-config.yazi.enable = lib.mkEnableOption "Yazi terminal file manager";
}
