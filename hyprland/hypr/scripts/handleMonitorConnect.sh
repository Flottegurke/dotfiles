#!/bin/sh

handle() {
  case $1 in monitoradded*)
    notify-send "New monitor detected" "mooving workspaces"
    hyprctl dispatch moveworkspacetomonitor "2 HDMI-A-2"
    hyprctl dispatch moveworkspacetomonitor "8 HDMI-A-2"
    hyprctl dispatch moveworkspacetomonitor "9 HDMI-A-2"
    hyprctl dispatch moveworkspacetomonitor "10 HDMI-A-2"
  esac
}

socat - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock" | while read -r line; do handle "$line"; done
