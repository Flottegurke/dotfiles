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
1. Create `users/<name>/default.nix`:
   ```nix
   { pkgs, ... }:
   {
     isNormalUser = true;
     shell = pkgs.zsh;
     extraGroups = [ "wheel" "networkmanager" ];
     description = "...";
   }
   ```

2. Optionally, create `users/<name>/home.nix`:
   ```nix
   { pkgs, ... }:
   {
     programs.git.enable = true;
     home.packages = [ pkgs.ripgrep ];
   }
   ```
3. Then generate and encrypt their password secret (see [`secrets/`](../secrets)) as `users-<name>-password.age`, and enable the account on whichever hosts it should should exist on:
   ```nix
   users-config.<name>.enable = true;
   ```

No other file needs editing since `default.nix` discovers the new directory automatically.
