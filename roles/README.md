# roles/
This Directory houses "Roles" which are a bundle of services, packages and settings that give a host a particular function or capability.
A role can represent anything from a standalone service (such as Vaultwarden) to an entire desktop environment, and multiple roles can be enabled together on a single host.


## Overview
Each subdirectory is automatically imported via [`default.nix`](./default.nix), which also generates a `roles-config.<name>.enable` option per directory. A role stays inert until explicitly enabled from a host.

**Mutual exclusive roles** must be asserted explicitly (e.g. `desktop-hyprland` and `desktop-kde` should never both be enabled on one host) - see [`default.nix`](./default.nix) for the assertion pattern.

## Resource allocation
| Port | Used by |
|---|---|

> [!NOTE]
> This table needs to be updated whenever a new role introduces a service with its own port, to avoid collisions when combining roles on one host.

## Files
| File | Purpose |
|---|---|
| [`default.nix`](./default.nix) | Imports all role configs located in this directory. |
| [`*/default.nix`](./default.nix) | The actual role config config. |

## Adding a new role
1. Create `roles/<name>/default.nix` (plus anny companion files):
   ```nix
   { lib, config, pkgs, ... }:
   lib.mkIf config.roles-config.<name>.enable {
     # roles-config.<base-role>.enable = true;

     # enable whatever services/packages this role needs
   
     # configure services
   }
   ```
2. If this role is mutually exclusive with another, add an assertion in `default.nix`.
