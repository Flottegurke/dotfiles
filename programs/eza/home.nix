{ config, lib, osConfig, ... }:
let
  aliases = {
    ls = "eza";
    ll = "eza --long --git --header";
    la = "eza --long --all --git --header";
    lt = "eza --tree --level=2";
  };
in
{
  xdg.configFile."eza/theme.yml" = lib.mkIf osConfig.programs-config.eza.enable {
      source = ./themes/catppuccin-mocha-sapphire.yml;
    };

  programs.eza = lib.mkIf osConfig.programs-config.eza.enable {
    enable = true;

    enableZshIntegration = config.programs.zsh.enable;
    enableBashIntegration = config.programs.bash.enable;

    colors = "auto";
    icons = "auto";

    extraOptions = [
      "--group-directories-first"
      "--hyperlink"
    ];
  };

  programs.zsh.shellAliases = lib.mkIf (osConfig.programs-config.eza.enable && config.programs.zsh.enable)
    aliases;

  programs.bash.shellAliases = lib.mkIf (osConfig.programs-config.eza.enable && config.programs.bash.enable)
    aliases;
}
