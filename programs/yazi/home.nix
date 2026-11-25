
{ config, lib, osConfig, pkgs, ... }:
{
  programs.yazi = lib.mkIf osConfig.programs-config.yazi.enable {
    enable = true;

    enableZshIntegration = config.programs.zsh.enable;
    shellWrapperName = "y";

    # Additional runtime dependencies
    extraPackages = with pkgs; [
      git
      wl-clipboard
    ];

    # Appearance
    flavors.catppuccin-mocha = ./flavors/catppuccin-mocha.yazi;

    theme = {
      flavor.dark = "catppuccin-mocha";

      git = {
        modified  = { fg = "#f9e2af"; }; # Yellow
        added     = { fg = "#a6e3a1"; }; # Green
        untracked = { fg = "#cba6f7"; }; # Mauve
        deleted   = { fg = "#f38ba8"; }; # Red
        updated   = { fg = "#74c7ec"; }; # Sapphire
        ignored   = { fg = "#6c7086"; }; # Overlay 0
      };
    };

    # Plugins
    plugins.git = {
      package = pkgs.yaziPlugins.git;
      setup = true;
      settings.order = 1500;
    };

    settings = {
      mgr = {
        sort_by = "natural";
        sort_dir_first = true;
        sort_sensitive = false;

        show_hidden = true;
        show_symlink = true;
      };

      preview = {
        wrap = "yes";
        tab_size = 4;
      };

      # Git status detection
      plugin.prepend_fetchers = [
        {
          url = "*";
          run = "git";
          group = "git";
        }
        {
          url = "*/";
          run = "git";
          group = "git";
        }
      ];
    };
  };
}

