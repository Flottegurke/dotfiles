# common/
This directory houses common NixOS settings and wires in the shared configuration trees ([`roles/`](../roles), [`services/`](../services), [`users/`](../users), [`modules/nixos/`](../modules)), [`programs/`](../programs).

## Overview
Anything here applies unconditionally to every host. If a setting should be optional or vary by machine, it belongs in [`roles/`](../roles) or [`modules/nixos/`](../modules) instead.

## Files
| File | Purpose |
|---|---|
| [`default.nix`](./default.nix) | Imports `roles/`, `services/`, `users/`, `modules/nixos/`, `home.nix`, and home-manager's NixOS module and sets universal settings (locale, networking, nix settings, bootloader, allowUnfree, overlays). |
| [`home.nix`](./home.nix) | Holds shared Home Manager settings (`useGlobalPkgs`, `useUserPackages`, `extraSpecialArgs`) and imports `programs/`. |

