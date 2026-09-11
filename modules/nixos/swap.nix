{ lib, config, ... }:
{
  options.swapSizeMB = lib.mkOption {
    type = lib.types.int;
    default = 8192;
    description = "Size of the swapfile, in MB.";
  };

  config.swapDevices = [{
    device = "/var/swapfile";
    size = config.swapSizeMB;
  }];
}
