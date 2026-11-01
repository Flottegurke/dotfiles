detect_signal() {
    command_exists signal-desktop
}

automatic_signal() {
    launch_program signal-desktop
}

guide_signal() {
    gum style --border rounded --padding "1 2" \
	"1. Open Signal (on phone) and go to Settings -> Linked devices -> Link a new device." \
        "2. Scan the QR code shown in Signal on this device." \
        "3. Name the linked device: $CURRENT_HOST"
}

cleanup_signal() {
    close_launched_program
    pkill -TERM -u "$EUID" -x signal-desktop 2>/dev/null || true # required due to possible handof to other process other then the originaly louched programm
}

register_program "signal" "Signal"
