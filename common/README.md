# common/
This directory houses common settings and wires in the shared config trees ([`roles/`](../roles), [`services/`](../services), [`users/`](../users), [`modules/nixos/`](../modules)).

## Overview
Anything here applies unconditionally to every host. If a setting should be optional or vary by machine, it belongs in [`roles/`](../roles) or [`modules/nixos/`](../modules) instead.

## Files
| File | Purpose |
|---|---|
| [`default.nix`](./default.nix) | Imports `roles/`, `services/`, `users/`, `modules/nixos/`, `home.nix`, and home-manager's NixOS module and sets universal settings (locale, networking, nix settings, bootloader, allowUnfree, overlays). |
| [`home.nix`](./home.nix) | Holds global home Manager settings (`useGlobalPkgs`, `sharedModules`, `extraSpecialArgs`). |
