{ lib, ... }:
{
  options.programs-config.fzf.enable = lib.mkEnableOption "fzf fuzzy finder";
}
