{ lib, stdenv, makeWrapper, gum, git, findutils, coreutils }:
stdenv.mkDerivation {
  pname = "config-new-host";
  version = "1.0.0";
  src = ./.;
  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp ${./config-new-host.sh} $out/bin/config-new-host
    chmod +x $out/bin/config-new-host
    wrapProgram $out/bin/config-new-host --prefix PATH : ${lib.makeBinPath [ gum git findutils coreutils ]}
  '';

  meta = with lib; {
    description = "Interactively generates a new NixOS host config";
    license = licenses.mit;
  };
}
