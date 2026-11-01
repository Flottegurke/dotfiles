final: prev: {
  # Package overrides are defined here, e.g.:
  # neovim = prev.neovim.overrideAttrs (old: {
  #   version = "0.11.0";
  #   src = prev.fetchFromGitHub {
  #     owner = "neovim"; repo = "neovim"; rev = "v0.11.0"; hash = "sha256-...";
  #   };
  # });


  rpi-imager = prev.rpi-imager.overrideAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      # Fix missing Material import on Qt 6.10+
      if ! grep -q '^import QtQuick.Controls.Material$' src/wizard/WritingStep.qml; then
        sed -i '/^import QtQuick.Controls$/a import QtQuick.Controls.Material' \
          src/wizard/WritingStep.qml
      fi

      grep -q '^import QtQuick.Controls.Material$' src/wizard/WritingStep.qml
    '';
  });
}
