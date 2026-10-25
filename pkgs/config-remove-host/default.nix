{ lib, stdenv, makeWrapper, gum, git, findutils, coreutils, agenix, gnugrep, gawk }:
stdenv.mkDerivation {
  pname = "config-remove-host";
  version = "1.0.0";
  src = ./.;
  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp ${./config-remove-host.sh} $out/bin/config-remove-host
    chmod +x $out/bin/config-remove-host
    wrapProgram $out/bin/config-remove-host --prefix PATH : ${lib.makeBinPath [ gum git findutils coreutils agenix gnugrep gawk ]}
  '';

  meta = with lib; {
    description = "Interactively removes a NixOS host config";
    license = licenses.mit;
  };
}
