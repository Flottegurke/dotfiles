# common/
This directory houses shared NixOS settings and wires in the configuration trees ([`roles/`](../roles), [`services/`](../services), [`users/`](../users), [`programs/`](../programs), [`modules/nixos/`](../modules)).

## Overview
Anything here applies to every host. If a setting should vary by role or machine, its enable switch belongs in [`roles/`](../roles) or a host module rather than in the common baseline.

## Files
| File | Purpose |
|---|---|
| [`default.nix`](./default.nix) | Imports `roles/`, `services/`, `users/`, `programs/`, `modules/nixos/`, `home.nix`, and the NixOS integration modules; sets universal host settings. |
| [`home.nix`](./home.nix) | Configures embedded Home Manager (`useGlobalPkgs`, `useUserPackages`, `extraSpecialArgs`) and loads `programs/home.nix`, custom HM modules, and plasma-manager through `sharedModules`. |

