# modules/
This directory houses custom NixOS and Home Manager modules (reusable building blocks that define their own `options`.

## Overview
`nixos/` and `home-manager/` each house their own `default.nix` aggregator that automatically imports every other file in its directory.
This means, that every module's options exist everywhere, gated by that module's own `enable` option.

## Files
| Path | Purpose |
|---|---|
| [`nixos/default.nix`](./nixos) / [`home-manager/default.nix`](./home-manager) | Auto-imports every custom home-manager module in its directory. |
| `home-manager/*.nix` / `nixos/*.nix`                                          | The actual custom modules. |


## Adding a new module
1. Create `modules/nixos/<name>.nix` or `modules/home-manager/<name>.nix`:
   ```nix
   { config, lib, pkgs, ... }:
   {
     options.services.my-thing = {
       enable = lib.mkEnableOption "my thing";
     };

     config = lib.mkIf config.services.my-thing.enable = {
       # ...
     };
   }
   ```
2. Enable it from any role or host:
   ```nix
   services.my-thing.enable = true;
   ```