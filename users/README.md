# users/
This directory houses user-account and Home Manager configurations, with every subdirectory being one user.

## Overview
Every subdirectory is picked up by [`default.nix`](./default.nix) which:
- builds a NixOS account for the user
- injects `hashedPasswordFile`, pointing at a matching `users-<name>-password.age` secret.
- wires their `home.nix` into `home-manager.users.<name>`, if present

A user only exists if enabled on the host:
```nix
users-config.flottegurke.enable = true;
```

## Files
| Path                          | Purpose                                                                                                                    |
|-------------------------------|----------------------------------------------------------------------------------------------------------------------------|
| `default.nix`                 | Auto discovers and builds user accounts.                                                                                   |
| `<name>/default.nix`          | Account data for the user (`isNormalUser`, `shell`, `extraGroups`, `description`, etc.).                                   |
| `<name>/wallpaper.nix` | Default wallpaper used on desktops. |
| `<name>/home.nix`             | **(optional)** Home Manager config for `<name>`.                                                                           |

## Adding a new user
1. Run the user creation wizzard:
   ```shell
   config-new-user
   ```
2. enable the user on the apropriate hosts
3. rebuild the system & push the new config
 
