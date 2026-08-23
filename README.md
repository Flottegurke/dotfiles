# dotfiles
This is my Unified NixOS configuration for multiple servers and desktops,
built with [flake-parts](https://flake.parts) + [home-manager](https://nix-community.github.io/home-manager) + [gnu-stow](https://www.gnu.org/software/stow), with [hyprland](https://hypr.land) as the wayland compositor on desktops.

## Overview

This repository is the single source of truth for:
- **desktops:** running Hyprland + Home Manager + GNU Stow, consisting of work/personal machines.
- **servers:** running headless services (web, database, etc.), managed entirely via the NixOS config, meaning almost no manual login is required.

All machines are defined as `nixosConfigurations` in one flake, sharing the same
pinned set of inputs via `flake.lock`. This means every host (desktop or server) is built against the exact same nixpkgs revision and module versions.

## Workflow: test locally, then deploy automatically

1. Changes (package bumps, new modules, config edits) are made and tested on non crittical **desktop** machines (`nix flake update`).
2. Once verified that nothing breaks, the updated `flake.lock` and any config changes are committed
   and pushed to this repository.
3. Each server automatically pulls the repository and rebuilds (`nixos-rebuild switch --flake .`) against the **exact same inputs** already validated on the desktop.

This means (input/config) updates are tested on non crittical hardware, before they reach production servers.

## Structure

| Directory | Purpose |
|---|---|
| [`hosts/`](./hosts) | Per-machine entry point (hostname, roles, hardware, other host-unique settings) |
| [`nixos/`](./nixos) | Generall NixOS config (common settings, roles, services) |
| [`home-manager/`](./home-manager) | Per-user dotfiles/program config |
| [`modules/`](./modules) | Custom NixOS/Home Manager modules (with their own `options`) |
| [`overlays/`](./overlays) | Package overrides/patches |
| [`pkgs/`](./pkgs) | Custom packages (not in nixpkgs) |
| [`secrets/`](./secrets) | Encrypted secrets (via agenix) |
| [`parts/`](./parts) | flake-parts modules wiring everything into flake outputs |
