{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "bsol-grub-theme";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "harishnkr";
    repo = "bsol";
    rev = "master";
    hash = "sha256-6c1KhxCSH+0S2cfVNatEh3AXsrCs0vCUQMFMYEiqO5s=";
  };

  installPhase = ''
    mkdir -p $out
    cp -r ./bsol/* $out/
  '';

  meta = with lib; {
    description = "GRUB2 blue-screen-of-life theme";
    license = licenses.gpl3; # corrected — repo is GPL-3.0, not MIT as I guessed earlier
    platforms = platforms.linux;
  };
}
