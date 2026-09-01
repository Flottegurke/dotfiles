# modules/
This directory houses custom NixOS and Home Manager modules (reusable building blocks that define their own `options`, rather than just setting values on options that already exist).

## Overview
There are two kinds of modules:
- [**`nixos/`**](./nixos) for NixOS modules
- [**`home-manager/`**](./home-manager) for home-manager modules

Each has its own `default.nix` aggregator that automatically imports every other file in its directory
This means, that every module's options exist everywhere, gated by that module's own `enable` option.

## Files
| Path | Purpose |
|---|---|
| [`nixos/default.nix`](./nixos) | Auto-imports every custom NixOS module in its directory. |
| [`home-manager/default.nix`](./home-manager) | Auto-imports every custom home-manager module in its directory. |
| `home-manager/*.nix` / `nixos/*.nix` | The actual custom modules. |


## Adding a new module
Create `modules/nixos/<name>.nix` or `modules/home-manager/<name>.nix`):

```nix
{ config, lib, pkgs, ... }:
let
  cfg = config.services.my-thing;
in
{
  options.services.my-thing = {
    enable = lib.mkEnableOption "my thing";
  };

  config = lib.mkIf cfg.enable {
    # ...
  };
}
```

No other file needs editing since the directorys `default.nix` discovers it automatically.

Enable it from any role or host:

```nix
services.my-thing.enable = true;
```
