{ lib, pkgs, osConfig, ... }:
lib.mkIf (lib.elem pkgs.git osConfig.environment.systemPackages) {
  programs.git = {
    enable = true;

    settings = {
      init.defaultBranch = "main";

      pull.ff = "only"; # prevent accidental merge commits when pulling
      push.autoSetupRemote = true;
      fetch.prune = true;

      core.editor = "vim";
      merge.conflictStyle = "zdiff3"; # show more context during merge conflicts
      commit.verbose = true; # show diff in commit message editor
    };

    ignores = [
      "*~"
      "*.swp"
      ".DS_Store"
    ];
  };
}
