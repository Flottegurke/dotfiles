# pkgs/
This directory houses custom package derivations (packages which are not available in `nixpkgs`).

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
{ lib, stdenv, makeWrapper }:
stdenv.mkDerivation {
  pname = "config-new-user";
  version = "1.0.0";
  src = ./.;
  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp ${./config-new-user.sh} $out/bin/config-new-user
    chmod +x $out/bin/config-new-user
    wrapProgram $out/bin/config-new-user --prefix PATH : ${lib.makeBinPath [ # programms the shells cript needs]}
  '';

  meta = with lib; {
    description = "";
    license = licenses.mit;
  };
}
```