# users/
This directory houses per user, account and Home Manager configuration, with every subdirectory beeing one user.

## Overview
Every subdirectory is picked up by [`default.nix`](./default.nix), which:
- builds a NixOS account for the user (`users.users.<name>`) using the information in `./<name>/default.nix`
- injects `hashedPasswordFile`, pointing at a matching `users-<name>-password.age` secret.
- wires their `home.nix` into `home-manager.users.<name>`, if present

A user only becomes real once enabled:
```nix
users-config.flottegurke.enable = true;
```

## Files
| Path | Purpose |
|---|---|
| `default.nix` | Auto discovers and builds user accounts. |
| `<name>/default.nix` | Account data for the user (`isNormalUser`, `shell`, `extraGroups`, `description`, etc). |
| `<name>/home.nix` | **This file is optional!** Home Manager config for `<name>` (`programs.*`, `home.packages`, etc). |

## Adding a new user
1. Run the user creation wizzard:
   ```shell
   config-new-user
   ```
2. Review wich host should have access to the user-secret (per defautl every host can decrypt it!)
3. enable the user on the apropriate hosts
4. rebuild the system & push the new config
 
