{ lib, stdenv, makeWrapper, gum, git, lazygit, openssh, gnused, gawk, findutils, coreutils, agenix }:

stdenv.mkDerivation {
  pname = "config-provision-host";
  version = "1.0.0";
  src = ./.;
  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp ${./config-provision-host.sh} $out/bin/config-provision-host
    chmod +x $out/bin/config-provision-host
    wrapProgram $out/bin/config-provision-host --prefix PATH : ${lib.makeBinPath [ gum git lazygit openssh gnused gawk findutils coreutils agenix ]}
  '';

  meta = with lib; {
    description = "Interactively Partitions and provisions a NixOS host via nixos-anywhere";
    license = licenses.mit;
  };
}
