#!/bin/bash

# Path to socket
SOCKET="$XDG_RUNTIME_DIR/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock"

# Avoid multiple script instances
PIDFILE="/tmp/hyprland-monitor-listener.pid"
if [ -f "$PIDFILE" ] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
    echo "Script already running."
    exit 1
fi
echo $$ > "$PIDFILE"

# Trap to cleanup PID file on exit
trap 'rm -f "$PIDFILE"' EXIT

# Event handler
handle() {
    case "$1" in
        monitoradded*)
            notify-send "New monitor detected"

            # Wait a moment to ensure monitor is fully initialized
            sleep 1

            notify-send "New monitor detected" "mooving workspaces"
            hyprctl dispatch moveworkspacetomonitor "1 eDP-1"
            hyprctl dispatch moveworkspacetomonitor "2 HDMI-A-2"
            hyprctl dispatch moveworkspacetomonitor "3 eDP-1"
            hyprctl dispatch moveworkspacetomonitor "4 eDP-1"
            hyprctl dispatch moveworkspacetomonitor "5 eDP-1"
            hyprctl dispatch moveworkspacetomonitor "6 eDP-1"
            hyprctl dispatch moveworkspacetomonitor "7 eDP-1"
            hyprctl dispatch moveworkspacetomonitor "8 HDMI-A-2"
            hyprctl dispatch moveworkspacetomonitor "9 HDMI-A-2"
            hyprctl dispatch moveworkspacetomonitor "10 HDMI-A-2"
	    ~/.config/hypr/scripts/changeWallpapers.sh
            ;;
    esac
}

# Listen to Hyprland events
socat - UNIX-CONNECT:"$SOCKET" | while read -r line; do
    handle "$line"
done
