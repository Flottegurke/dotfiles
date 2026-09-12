{ lib, stdenv, makeWrapper, gum, mkpasswd, git, agenix }:
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
    wrapProgram $out/bin/config-new-user --prefix PATH : ${lib.makeBinPath [ gum mkpasswd git agenix ]}
  '';

  meta = with lib; {
    description = "Interactively generates a new NixOS user + encrypted password secret";
    license = licenses.mit;
  };
}
