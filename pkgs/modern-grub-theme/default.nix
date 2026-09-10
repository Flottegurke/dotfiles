{ lib, stdenv }:
stdenv.mkDerivation {
  pname = "modern-grub-theme";
  version = "1.0.0";
  src = ./.;

  dontBuild = true;

  installPhase = ''
    mkdir -p $out
    cp -r ./* $out/
  '';

  meta.description = "Custom GRUB theme, forked from elegant-grub2-themes";
}
