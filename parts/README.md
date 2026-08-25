# parts/
This directory houses [flake-parts](https://flake.parts) modules that wire the rest of this repository into actual flake outputs (`nixosConfigurations`, `packages`, etc).
Each file defines one concern and gets merged automatically via `imports` in the root `flake.nix`.

## Overview
There are two kinds of modules:
- **`perSystem`:** for outputs that exist once per architecture (packages, devShells). flake-parts runs these once per entry in `systems`.
- **`flake`:** for outputs tied to a specific host or user rather than an architecture (`nixosConfigurations`).

## Files
| File | Purpose |
|---|---|
| [`nixos-hosts.nix`](./nixos-hosts.nix) | Builds `nixosConfigurations.<name>` for every directory under [`hosts/`](../hosts). |
| [`packages.nix`](./packages.nix) | Builds `packages.<name>` for every directory under [`pkgs/`](../pkgs). |
