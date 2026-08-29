# overlays/
This directory houses overrides and patches for existing `nixpkgs` packages.

## Overview
An overlay is a function `final: prev: { ... }` that modifies the `pkgs` set itself. `prev` is `pkgs` before this overlay's changes; `final` is `pkgs` after all overlays are applied, used when one override needs to reference another. What the function returns is merged on top of `prev`, becoming the new `pkgs` for the entire host it's applied to.

## Files
| File | Purpose |
|---|---|
| [`default.nix`](./default.nix) | The list of overlay functions applied to every host. |

## Adding an override
Add an entry inside the returned attrset in `default.nix`:

```nix
final: prev: {
  neovim = prev.neovim.overrideAttrs (old: {
    version = "0.11.0";
    src = prev.fetchFromGitHub {
      owner = "neovim"; repo = "neovim"; rev = "v0.11.0"; hash = "sha256-...";
    };
  });
}
```
