{ config, lib, osConfig, ... }:
{
  programs.fzf = lib.mkIf osConfig.programs-config.fzf.enable {
    enable = true;
    enableZshIntegration = false; # Keep fzf-tab responsible for Tab completion

    colors = {
      bg = "#1e1e2e";
      "bg+" = "#313244";
      fg = "#cdd6f4";
      "fg+" = "#cdd6f4";
      hl = "#f38ba8";
      "hl+" = "#f38ba8";
      spinner = "#f5e0dc";
      header = "#f38ba8";
      info = "#cba6f7";
      pointer = "#f5e0dc";
      marker = "#b4befe";
      prompt = "#cba6f7";
      "selected-bg" = "#45475a";
      border = "#6c7086";
      label = "#cdd6f4";
    };
  };
}

