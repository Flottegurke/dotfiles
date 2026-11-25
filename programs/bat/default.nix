{ lib, ... }:
{
  options.programs-config.bat.enable = lib.mkEnableOption "bat syntax-highlighted file viewer";
}
