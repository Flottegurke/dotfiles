{ lib, ... }:
{
  options.programs-config.kitty.enable = lib.mkEnableOption "Kitty terminal emulator";
}
