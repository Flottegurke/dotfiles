# hosts/
This Directory houses the entry points per machine, with each subdirectory beeing one physical or virtual machine.

## Overview
Host configs declare whatever is unique to this machine (hostname, disk layout, static IP). Shared behavior (services, roles, modules, universal settings) is imported from [`common/`](../common).

A host's default.nix is a attrset with 2 keys, not a NixOS module:
```nix
{
  meta = {
    isDesktop = true;
    isAdmin = false;
  };

  module = { lib, config, pkgs, ... }:
  {
    networking.hostName = "laptop-x1";
    nixpkgs.hostPlatform = "x86_64-linux";

    roles-config.desktop-hyprland.enable = true;
    roles-config.laptop.enable = true;

    users-config.flottegurke.enable = true;
  };
}
```
- **`meta`:** plain data, consumed by [`secrets/keys.nix`](../secrets/keys.nix) to derive groups for secrets access
- **`module`:** the actual NixOS module, configuring the hosts NixOS system

## Files
| Path | Purpose |
|---|---|
| `<name>/default.nix` | Per machine entry point (hostname, role selection, user enablement, host-unique overrides) |
| `<name>/hardware-configuration.nix` | Auto-generated hardware config (Filesystems, kernel modules, CPU microcode) |
| `<name>/disko.nix` | Disk partitioning (for provisioning via `nixos-anywhere`/`disko`) |

## Adding a new host
1. Run the host config creation wizzard:
   ```shell
   config-new-host
   ```
2. Track & commit canges in git
