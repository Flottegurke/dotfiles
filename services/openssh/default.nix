# host should set services.openssh.ports
{ lib, config, ... }:
lib.mkIf config.services.openssh.enable {
  services.openssh = {
    openFirewall = true;
    generateHostKeys = true;
    allowSFTP = true;
    sftpFlags = [ "-l" "INFO" ];
    hostKeys = [{ path = "/etc/ssh/ssh_host_ed25519_key"; type = "ed25519"; }];
    startWhenNeeded = true;

    settings = {
      # general
      PrintMotd = true;
      LogLevel = "INFO";
      StrictModes = true;
      AllowTcpForwarding = true;

      # security
      AddressFamily = "any";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PubkeyAuthentication = true;
      UsePAM = true;
      MaxAuthTries = 2;
      MaxStartups = "10:30:50";
      PermitRootLogin = "no";
      PermitEmptyPasswords = false;
      IgnoreRhosts = true;
      AuthorizedKeysFile = ".ssh/authorized_keys";
      HostbasedAuthentication = false;
      PubkeyAcceptedAlgorithms = "ssh-ed25519";
      KexAlgorithms = [ "sntrup761x25519-sha512@openssh.com" "curve25519-sha256" ];
      Ciphers = [ "chacha20-poly1305@openssh.com" "aes256-gcm@openssh.com" ];
      Macs = [ "hmac-sha2-512-etm@openssh.com" ];

      # session
      PermitUserEnvironment = false;
      PrintLastLog = true;
      TCPKeepAlive = true;
      ClientAliveInterval = 300;
      ClientAliveCountMax = 4;
      LoginGraceTime = "30s";
      MaxSessions = 10;

      # unwanted features
      GatewayPorts = "no";
      AllowAgentForwarding = false;
      X11Forwarding = false;
      AllowStreamLocalForwarding = false;
      PermitTunnel = false;
    };
  };
}

