# dotfiles
This is my NixOS configuration for multiple servers and desktops, built with [flake-parts](https://flake.parts), [home-manager](https://nix-community.github.io/home-manager) and [agenix](https://github.com/ryantm/agenix), with [hyprland](https://hypr.land) or [kde-plasma](https://kde.org/de/plasma-desktop/) as the wayland compositor on desktops.

## Overview
This repository is the single source of truth for:
- **desktops:** running Hyprland/kde-plasma, consisting of work/personal machines.
- **servers:** managed entirely via the NixOS config, meaning almost no manual login is required.

All machines are defined as `nixosConfigurations` in one flake, sharing the same pinned set of inputs via `flake.lock`.
This means every host (desktop or server) is built against the same `nixpkgs` revision and module versions.

## Workflow: test locally, deploy automatically
1. Changes (package bumps, new modules, config edits) are made and tested on non-critical **desktop** machines (`nix flake update`).
2. Once verified that nothing breaks, the updated `flake.lock` and any config changes are committed and pushed to this repository.
3. Each server automatically pulls the repository (based on a cron job (every Saturday at 8AM)) and rebuilds (`nixos-rebuild switch --flake .#<hostname>`) against the same inputs already validated on the desktop.

This means (input/config) updates are tested on non-critical hardware, before they reach production servers.

## Structure

| Directory | Purpose |
|---|---|
| [`hosts/`](./hosts) | Per-machine entry point (hostname, disk layout, roles, users, etc.) |
| [`common/`](./common) | Common settings used by every host (home-manager setup, agenix setup, modules import, etc.) |
| [`roles/`](./roles) | Reusable `Role` definitions (desktop-hyprland, vaultwarden, matrix, etc.) |
| [`services/`](./services) | Individual service (hardening) configs (ssh, nginx, postgresql, etc.) |
| [`users/`](./users) | user-account definitions (home-manager options, default shell, groups, etc.) |
| [`modules/`](./modules) | Custom NixOS/Home Manager modules (swap, etc.) |
| [`overlays/`](./overlays) | Package overrides/patches |
| [`pkgs/`](./pkgs) | Custom packages (not in `nixpkgs`) (config-new-user, config-new-host, config-provision-host, etc.) |
| [`secrets/`](./secrets) | encrypted secrets / agenix config (host SSH-key grouping, ACL's) |
| [`parts/`](./parts) | `flake-parts` modules wiring everything into flake outputs |
