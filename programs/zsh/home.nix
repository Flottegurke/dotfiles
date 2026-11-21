{ config, lib, pkgs, ... }:
{
  xdg.configFile."fsh/catppuccin-mocha.ini" = lib.mkIf config.programs.zsh.enable {
    source = ./themes/catppuccin-mocha.ini;
  };

  programs.zsh = lib.mkIf config.programs.zsh.enable {
    enableCompletion = true;

    autosuggestion = {
      enable = true;
      strategy = [
        "history"
        "completion"
      ];
      highlight = "fg=#7f849c"; # Catppuccin mocha Overlay 1
    };

    initContent = lib.mkMerge [
      (lib.mkOrder 600 ''
        # fzf-tab
        zstyle ':completion:*:descriptions' format '[%d]'
        zstyle ':completion:*' menu no
        zstyle ':completion:*:git-checkout:*' sort false
        zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
        zstyle ':fzf-tab:*' show-group full

        # File and directory previews
        zstyle ':fzf-tab:complete:*:*' fzf-preview '
          if [[ -n "$realpath" && -d "$realpath" ]]; then
            ${pkgs.eza}/bin/eza -la --group-directories-first --color=always -- "$realpath"
          elif [[ -n "$realpath" && -f "$realpath" ]]; then
            ${pkgs.bat}/bin/bat --color=always --style=numbers --line-range=:200 -- "$realpath"
          fi
        '
        zstyle ':fzf-tab:complete:*:options' fzf-preview # No file preview for command options

        zstyle ':fzf-tab:*' use-fzf-default-opts yes
        # Catppuccin Mocha with Sapphire accent
        #zstyle ':fzf-tab:*' fzf-flags \
          #'--color=fg:#cdd6f4,fg+:#cdd6f4,bg:#1e1e2e,bg+:#313244,hl:#74c7ec,hl+:#74c7ec,prompt:#74c7ec,pointer:#74c7ec,marker:#a6e3a1,info:#a6adc8,header:#a6adc8' \
          #'--preview-window=right:50%:wrap'

        source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
      '')

      (lib.mkOrder 2000 ''
        # Autosuggestion keybinding
        bindkey '^@' autosuggest-accept

        # Fast Syntax Highlighting
        export FAST_WORK_DIR="''${XDG_CACHE_HOME:-$HOME/.cache}/fsh"
        mkdir -p "$FAST_WORK_DIR"

        source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

        fast-theme -q XDG:catppuccin-mocha
      '')
    ];

  };
}
