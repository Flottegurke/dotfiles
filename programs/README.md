# programs/
This directory houses application-specific configuration for both NixOS and Home Manager.

## Overview
Each program has its own subdirectory. The two module systems are loaded independently:
- [`default.nix`](./default.nix) automatically imports `programs/<name>/default.nix` as **NixOS modules**.
- [`home.nix`](./home.nix) automatically imports `programs/<name>/home.nix` as **Home Manager modules** for each enabled Home Manager user.

**What belongs here:** package installation, application-wide NixOS policies, program-specific agenix integration, and application specific Home Manager settings. NixOS and Home Manager options must stay in their respective module files.

A directory can have just `default.nix`, just `home.nix`, or both. Supporting files such as `policy.nix` are only loaded when explicitly imported by another module.

## Files
| Path | Purpose |
|---|---|
| [`default.nix`](./default.nix) | NixOS auto-discovery for each `<name>/default.nix`. |
| [`home.nix`](./home.nix) | Home Manager auto-discovery for each `<name>/home.nix`. |
| `<name>/default.nix` | **(optional)** NixOS configuration, including installation and system-wide policies. |
| `<name>/home.nix` | **(optional)** Shared Home Manager configuration and per-user preferences. |
| `<name>/*` | **(optional)** Plain Nix data, templates, and native config files referenced by modules. |

## Adding a new program
1. Create `programs/<name>/default.nix` if it needs NixOS configuration. For example, define a custom enable option and install the package when enabled:
   ```nix
   { lib, config, pkgs, ... }:
   {
     options.programs-config.example.enable = lib.mkEnableOption "Example program";

     config = lib.mkIf config.programs-config.example.enable {
       environment.systemPackages = [ pkgs.hello ];
     };
   }
   ```
2. Create `programs/<name>/home.nix` if it needs shared Home Manager settings. Use `osConfig` to gate settings against the evaluated NixOS configuration, rather than a particular desktop role.
