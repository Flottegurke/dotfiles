# pkgs/
This directory houses custom package derivations not available in `nixpkgs`.
Each subdirectory is one package, automatically discovered and exposed as a flake output.

## Overview
Every directory is picked up by [`parts/packages.nix`](../parts/packages.nix), which calls `pkgs.callPackage` on it and exposes the result as `packages.<name>` for every system in `flake.nix`'s `systems` list.

The directory name becomes the package name, referenceable from any NixOS config as `inputs.self.packages.${system}.<name>`.

## Files
| Path | Purpose |
|---|---|
| `<name>/default.nix` | Derivation for the package `<name>` (beeing a function taking its build inputs as arguments) |

## Adding a new package

Create `pkgs/<name>/default.nix` as a standard derivation:
```nix
{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "<name>";
  version = "1.0.0";
  src = fetchFromGitHub { owner = ""; repo = ""; rev = ""; hash = ""; }; # or ./.

  installPhase = ''
    mkdir -p $out/bin
    cp <name>.sh $out/bin/<name>
    chmod +x $out/bin/<name>
  '';

  meta = with lib; {
    description = "...";
    license = licenses.mit;
  };
}
```
No other file needs editing since `parts/packages.nix` discovers it automatically on the next evaluation.
