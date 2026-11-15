{ lib, osConfig, ... }:
lib.mkIf osConfig.programs.iftop.enable {
  home.file.".iftoprc".text = ''
    dns-resolution: yes
    port-resolution: yes
    show-bars: yes
    port-display: on
    use-bytes: yes
    sort: 10s
    line-display: one-line-both
    show-totals: yes
    something: yes
    log-scale: no
  '';
}
