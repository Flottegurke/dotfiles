# programs/
This directory houses shared Home Manager configurations.

## Overview
Every subdirectory containing a `default.nix` is automatically discovered by [`default.nix`](./default.nix) and applied to every user.
Every module stays inactive unless the application is enabled.

**What belongs here:** Home Manager options (`programs.git`, `programs.ssh`, `programs.plasma`, etc.), `xdg.configFile` and other shared per-user settings.

**What does not belong here:** NixOS options.

## Files
| Path | Purpose |
|---|---|
| [`default.nix`](./default.nix) | Imports all program configs located in this directory. |
| `<name>/default.nix` | Home Manager settings for an application. |

## Adding a new program
1. Create `programs/<name>/default.nix`. For example, an application installed in `environment.systemPackages` can be configured without installing another copy through Home Manager:
   ```nix
   { lib, pkgs, osConfig, ... }:
   lib.mkIf (lib.elem pkgs.kitty osConfig.environment.systemPackages) {
     xdg.configFile."kitty/kitty.conf".source = ./kitty.conf;
   }
   ```
2. Put `kitty.conf` next to `default.nix`.
3. Keep personal values in [`users/<name>/home.nix`](../users) rather than duplicating shared settings.
