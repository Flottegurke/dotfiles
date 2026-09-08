# roles/
This Directory houses "Roles" which are a bundle of services, packages, and settings that define "what kind of machine this host is."

## Overview
Each subdirectory is automatically imported via [`default.nix`](./default.nix), which also generates a `roles-config.<name>.enable` option per directory. A role stays inert until explicitly enabled from a host.

**Mutual exclusive roles** must be asserted explicitly (e.g. `desktop-hyprland` and `desktop-kde` should never both be enabled on one host) - see [`default.nix`](./default.nix) for the assertion pattern.

## Port / resource allocation
| Port | Used by |
|---|---|

> [!NOTE]
> This table needs to be updated whenever a new role introduces a service with its own port, to avoid collisions when combining roles on one host.

## Files
| File | Purpose |
|---|---|
| [`default.nix`](./default.nix) | Imports all role configs located in this directory. |
| [`*/default.nix`](./default.nix) | The actual service config. |

## Adding a new role
1. Create `roles/<name>/default.nix` plus anny companion files:
   ```nix
   { lib, config, pkgs, ... }:
   lib.mkIf config.roles-config.<name>.enable {
     # cascade any base role this one extends:
     # roles-config.<base-role>.enable = true;

     # enable whatever services/packages this role needs
   }
   ```
2. If this role is mutually exclusive with another, add an assertion in `default.nix`.
No other file needs editing - `default.nix` discovers the new directory and generates its `enable` option automatically.
