detect_thunderbird() {
    command_exists thunderbird
}

automatic_thunderbird() {
    launch_program thunderbird
}

guide_thunderbird() {
    gum style --border rounded --padding "1 2" \
	"1. Enter the Mail Password."
}

cleanup_thunderbird() {
    close_launched_program
}

register_program "thunderbird" "Thunderbird"
