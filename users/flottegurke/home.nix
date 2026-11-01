{ config, pkgs, lib, osConfig, ... }:
{
  programs.git.settings.user = {
    name = "flottegurke";
    email = "justus.dicker@web.de";
  };

  home.packages = with pkgs; [
  ];

  home.file = {
  };

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  home.stateVersion = "26.05"; # DO NOT CENTRALISE / CHANGE
}
