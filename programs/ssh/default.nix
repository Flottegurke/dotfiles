{ lib, pkgs, osConfig, ... }:
lib.mkIf (lib.elem pkgs.openssh osConfig.environment.systemPackages) {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks."github.com" = {
      hostname = "ssh.github.com";
      user = "git";
      port = 443;
    };

    settings."*" = {
      ForwardAgent = false;
      ServerAliveInterval = 30;
      ServerAliveCountMax = 3;
    };
  };
}
