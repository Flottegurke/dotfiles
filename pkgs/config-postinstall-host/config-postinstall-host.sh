#!/usr/bin/env bash

set -euo pipefail

REPO_URL="https://github.com/flottegurke/dotfiles.git"
DOTFILES_DIR="$HOME/.config/dotfiles"
CURRENT_HOST="$(hostname)"
PROGRAMS_DIR="${POSTINSTALL_MODULE_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/programs}"

PROGRAM_PID=""
declare -a REGISTERED_PROGRAMS=()
declare -A PROGRAM_DISPLAY_NAMES=()


header=$(gum style --border rounded --padding "1 2" --margin "5 2 1 2" --bold "Post-install NixOS host")
description=$(gum style --padding "0 0 5 0" --faint "This will finish configuring applications and the local system")
gum join --vertical --align center "$header" "$description"

if (( EUID == 0 )); then
    gum style --foreground 1 "Run config-postinstall-host as your normal user, not root."
    exit 1
fi


# -------------------- Helper functions --------------------

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

register_program() {
    local program_id="$1"
    local display_name="$2"

    if [[ ! "$program_id" =~ ^[a-z][a-z0-9_]*$ ]]; then
        gum log --level error "Invalid program ID: $program_id"
        return 1
    fi

    if [[ -v "PROGRAM_DISPLAY_NAMES[$program_id]" ]]; then
        gum log --level error "Program '$program_id' was registered twice."
        return 1
    fi

    if ! declare -F "detect_${program_id}" >/dev/null; then
        gum log --level error "Module '$program_id' must define detect_${program_id}()."
        return 1
    fi

    REGISTERED_PROGRAMS+=("$program_id")
    PROGRAM_DISPLAY_NAMES["$program_id"]="$display_name"
}

launch_program() {
    PROGRAM_PID=""

    "$@" </dev/null >/dev/null 2>&1 &
    PROGRAM_PID=$!
}

close_launched_program() {
    if [[ -n "$PROGRAM_PID" ]] && kill -0 "$PROGRAM_PID" 2>/dev/null; then
        kill "$PROGRAM_PID" 2>/dev/null || true
        wait "$PROGRAM_PID" 2>/dev/null || true
    fi

    PROGRAM_PID=""
}

trap 'close_launched_program' EXIT

run_program_setup() {
    local program_id="$1"
    local display_name="${PROGRAM_DISPLAY_NAMES[$program_id]}"
    local action=""

    echo
    gum style --bold "$display_name"
    if ! "detect_${program_id}"; then
        gum log --level info "$display_name is not installed. Skipping."
        return 0
    fi
    gum log --level info "$display_name detected."

    if ! gum confirm "Customise ${display_name}?"; then
        gum style --foreground 3 "Skipping $display_name."
        return 0
    fi

    if declare -F "automatic_${program_id}" >/dev/null; then
        gum log --level info "Applying automatic setup for $display_name..."
        if ! "automatic_${program_id}"; then
            gum log --level error "Automatic setup failed for $display_name. Continuing to the next program."
            if declare -F "cleanup_${program_id}" >/dev/null; then
                "cleanup_${program_id}"
            fi
            return 0
        fi
    fi

    if declare -F "guide_${program_id}" >/dev/null; then
        echo
        "guide_${program_id}"
        echo
        if ! gum confirm "Finished setting up ${display_name}?"; then
            action="unfinished"
            gum log --level warn "Marked $display_name as unfinished."
        fi
    fi

    if declare -F "cleanup_${program_id}" >/dev/null; then
        "cleanup_${program_id}"
    fi

    if [[ "$action" != "unfinished" ]]; then
        gum style --foreground 2 "$display_name setup completed."
    fi
}


# -------------------- pre programm customisation setup --------------------

gum style --bold "Dotfiles configuration"
if [[ -d "$DOTFILES_DIR" ]]; then
    if git -C "$DOTFILES_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        gum log --level info "Dotfiles repository already exists at $DOTFILES_DIR."
    else
        gum style --foreground 1 "'$DOTFILES_DIR' exists but is not a Git checkout."
        gum style --faint "Move it out of the way manually if you want to clone the repository."
    fi
else
    gum log --level info "No dotfiles repository found."
    if gum confirm "Clone the dotfiles repository to ~/.config/dotfiles?"; then
        mkdir -p "$HOME/.config"
        gum log --level info "Cloning dotfiles repository..."
        if git clone "$REPO_URL" "$DOTFILES_DIR"; then
            gum style --foreground 2 "Dotfiles repository cloned successfully."
        else
            gum style --foreground 1 "Git clone failed."
	    exit 1
        fi
    else
        gum style --foreground 3 "Skipped cloning dotfiles."
    fi
fi


# -------------------- programm customisation  --------------------

if [[ ! -d "$PROGRAMS_DIR" ]]; then
    gum log --level error "Post-install modules directory not found: $PROGRAMS_DIR"
    exit 1
fi
shopt -s nullglob
for module in "$PROGRAMS_DIR"/*.sh; do
    # Every module defines hooks and registers itself with register_program.
    source "$module"
done
shopt -u nullglob
gum style --border rounded --padding "1 2" --bold "Application setup"
if [[ ${#REGISTERED_PROGRAMS[@]} -eq 0 ]]; then
    gum log --level warn "No program setup modules were registered."
else
    for program_id in "${REGISTERED_PROGRAMS[@]}"; do
        run_program_setup "$program_id"
    done
fi


# -------------------- post programm customisation cleanup --------------------

echo
gum style --border rounded --padding "1 2" --bold --foreground 2 "Post-install application setup finished!"
echo

if [[ -f "$DOTFILES_DIR/flake.nix" && -d "$DOTFILES_DIR/hosts/$CURRENT_HOST" ]]; then
    if gum confirm "Rebuild NixOS from ~/.config/dotfiles for ${CURRENT_HOST}?"; then
        gum log --level info "Rebuilding ${CURRENT_HOST}..."

        if sudo nixos-rebuild switch --flake "$DOTFILES_DIR#$CURRENT_HOST"; then
            gum style --foreground 2 "Rebuild completed successfully."
        else
            gum style --foreground 1 "Rebuild failed. Review the error before restarting."
        fi
    fi
else
    gum log --level warn "No usable flake configuration found for '$CURRENT_HOST' in $DOTFILES_DIR."
    gum style --faint "Skipping the rebuild prompt."
fi

echo
if gum confirm "Restart the machine now?"; then
    gum log --level info "Restarting..."
    sudo systemctl reboot
fi

gum style --faint "Post-install setup finished."
