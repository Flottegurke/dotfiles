{ lib, stdenv, makeWrapper, bash, gum, git, coreutils, procps, inetutils, systemd}:
stdenv.mkDerivation {
  pname = "config-postinstall-host";
  version = "1.0.0";
  src = ./.;
  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p "$out/bin" "$out/share/config-postinstall-host/programs"
    install -m 0755 "$src/config-postinstall-host.sh" "$out/bin/config-postinstall-host"
    cp -r "$src/programs/." "$out/share/config-postinstall-host/programs/"
    wrapProgram "$out/bin/config-postinstall-host" --set POSTINSTALL_MODULE_DIR "$out/share/config-postinstall-host/programs" \
      --prefix PATH : "${lib.makeBinPath [ bash gum git coreutils procps inetutils systemd]}"
  '';

  meta = with lib; {
    description = "Interactive NixOS post-install setup";
    license = licenses.mit;
  };
}
