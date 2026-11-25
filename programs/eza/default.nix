{ lib, ... }:
{
  options.programs-config.eza.enable = lib.mkEnableOption "eza directory listings";
}
