# hosts/
This Directory houses the entry points per machine, with each subdirectory beeing one physical or virtual machine.

## Overview
Host configs declare whatever is unique to this machine (hostname, disk layout, static IP). Shared behavior (services, roles, modules, universal settings) is imported from [`common/`](../common).

## Files
| Path | Purpose |
|---|---|
| `<name>/default.nix` | Per machine entry point (hostname, role selection, user enablement, host-unique overrides) |
| `<name>/hardware-configuration.nix` | Auto-generated hardware config (Filesystems, kernel modules, CPU microcode) |
| `<name>/disko.nix` | Disk partitioning (for provisioning via `nixos-anywhere`/`disko`) |

## A typical host file
```nix
# hosts/server-web03/default.nix
{
  networking.hostName = "server-web03";
  nixpkgs.hostPlatform = "x86_64-linux";

  roles-config.vaultwarden-server.enable = true;

  users-config.flottegurke.enable = true;

  swapSizeMB = 2048; # override the default set in modules/nixos/swap.nix
}
```

## Adding a new host
1. Create `hosts/<name>/`.
2. Provision it (see the root README's workflow section, or [`nixos-anywhere`](https://github.com/nix-community/nixos-anywhere) for remote installs), producing `hardware-configuration.nix` (and `disko.nix`, if declaratively partitioned).
3. Write `default.nix`: hostname, platform, role(s), enabled user(s), any host-unique overrides.
4. `git add hosts/<name>` — new files must be tracked before the flake evaluator sees them.
5. `nixos-rebuild switch --flake .#<name>` (locally) or let it pick up on the next scheduled deploy (see root README).

No other file needs editing — `parts/nixos-hosts.nix` discovers the new directory automatically.
