# users/
This directory houses user accounts, individual Home Manager settings, and user-specific NixOS secret wiring.

## Overview
Every subdirectory is picked up by [`default.nix`](./default.nix) which:
- builds a NixOS account for the user
- injects `hashedPasswordFile`, pointing to the matching `users-<name>-password.age` secret
- wires `home.nix` into `home-manager.users.<name>` when present
- imports `secrets.nix` when present

A user only exists if enabled on the host:
```nix
users-config.flottegurke.enable = true;
```

## Files
| Path | Purpose |
|---|---|
| [`default.nix`](./default.nix) | Discovers users, builds accounts and passwords, and wires HM users. |
| `<name>/default.nix` | Account data for the user (`isNormalUser`, `shell`, `extraGroups`, `description`, etc.). |
| `<name>/home.nix` | **(optional)** Personal HM settings. |
| `<name>/secrets.nix` | **(optional)** Personal NixOS agenix declarations. |
| `<name>/wallpaper.png` | **(optional)** Personal desktop wallpaper. |

## Adding a new user
1. Run the user creation wizzard:
   ```shell
   config-new-user
   ```
2. enable the user on the apropriate hosts
3. rebuild the system & push the new config
 
