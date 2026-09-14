# hosts/
This Directory houses the entry points per machine.

## Overview
The `hosts/<name>/default.nix` file, which typically looks like this:
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
declares 2 things:
1. **`meta` block:** is consumed by [`secrets/keys.nix`](../secrets/keys.nix) to derive groups for secrets access.
2. **`module` block:** is the actual NixOS module configuring host specific NixOS settings.

Disk information is stored in `hosts/<name>/disko.nix` and used by disko while the provisioning of new hosts.

## Files
| Path | Purpose |
|---|---|
| `<name>/default.nix` | Host Specific NixOS and secrets-group config |
| `<name>/hardware-configuration.nix` | Auto-generated hardware config (Filesystems, kernel modules, CPU microcode) |
| `<name>/disko.nix` | Disk partitioning (for provisioning of new hosts) |

## Adding a new host
1. Run the host config creation wizzard:
   ```shell
   config-new-host
   ```
2. Track & commit canges in git
