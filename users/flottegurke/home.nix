{ config, pkgs, lib, osConfig, ... }:

{

  home.packages = with pkgs; [
  ] ++ lib.optionals osConfig.roles-config.desktop-kde.enable [
    (pkgs.catppuccin-kde.override { flavour = [ "mocha" ]; accents = [ "sapphire" ]; })
  ];

  home.file = {
  };


  # dektop-kde
  programs.plasma = lib.mkIf osConfig.roles-config.desktop-kde.enable {
    enable = true;
    workspace = {
      wallpaper = ./wallpaper.png;
      colorScheme = "CatppuccinMochaSapphire";
      theme = "breeze-dark";
    };
    panels = [
      {
        location = "bottom";
        widgets = [
          "org.kde.plasma.kickoff"
          "org.kde.plasma.icontasks"
          "org.kde.plasma.systemtray"
          "org.kde.plasma.digitalclock"
        ];
      }
    ];
  };


  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/flottegurke/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  home.stateVersion = "26.05"; # DO NOT CENTRALISE / CHANGE
}
