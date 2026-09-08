# services/
This directory houses service-level defaults (mostly hardening defaults) which are enabled by hosts or roles.

## Overview
Every subdirectiry is automatically imported via [`default.nix`](./default.nix).
Each config guards its actual effect with `lib.mkIf config.services.<x>.enable`, meaning it stays inert until a [`role`](../roles) or host flips that service on.

**What belongs here:** settings which are identical no matter which host runs the service (TLS hardening, recommended defaults, firewall rules tied to the service itself, etc).

## Files
| File | Purpose |
|---|---|
| [`default.nix`](./default.nix) | Imports all service configs located in its directory. |
| `*/defult.nix` | The actual service configs. |

## Adding a new service
1. Create `services/<name>/default.nix` plus anny companion files:
   ```nix
   { lib, config, ... }:
   lib.mkIf config.services.<name>.enable {
     # ...
   }
   ```
2. Add values that must be set by the host once this config is active as a comment, inorder to speedup the configuration process for the next usecase

> [!CAUTION]
> Every default service config must take into account that different roles, each activating the same sevice, might get activated on the same host.
> Due to this, no value that neds to get changed if this service has to run multiple times per host (eg. a port number) is allowed to be set in the service config and must be set in the host config instead!

No other file needs editing since `default.nix` discovers the new service config automatically.
