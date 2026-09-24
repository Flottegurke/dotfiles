#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$HOME/.config/dotfiles"
HOSTS_DIR="$REPO_ROOT/hosts"
SECRETS_DIR="$REPO_ROOT/secrets"
KEYS_DATA="$SECRETS_DIR/keys-data.nix"


header=$(gum style --border rounded --padding "1 2" --margin "5 2 1 2" --bold "Provision a NixOS host")
description=$(gum style --padding "0 0 5 0" --faint "This will partition and provision a host via nixos-anywhere")
gum join --vertical --align center "$header" "$description"


# -------------------- Collect target host information --------------------

mapfile -t AVAILABLE_HOSTS < <(find "$HOSTS_DIR" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort)
HOSTNAME_INPUT="$(gum choose --header "Host to provision:" "${AVAILABLE_HOSTS[@]}")"
if [[ -z "$HOSTNAME_INPUT" ]]; then
    gum style --foreground 1 "A host needs to be selected."
    exit 1
fi

HOST_DIR="$HOSTS_DIR/$HOSTNAME_INPUT"

DISKO_FILE="$HOST_DIR/disko.nix"
if [[ ! -e "$DISKO_FILE" ]]; then
    gum style --foreground 1 "No disko.nix found for '$HOSTNAME_INPUT'."
    exit 1
fi

TARGET_IP="$(gum input --placeholder "target-ip" --prompt "Target IP: ")"
if [[ -z "$TARGET_IP" ]]; then
    gum style --foreground 1 "Target IP cannot be empty."
    exit 1
fi
gum log --level info "Checking SSH reachability of root@${TARGET_IP}..."
if ! ssh -o StrictHostKeyChecking=accept-new -o ConnectTimeout=5 "root@${TARGET_IP}" true 2>/dev/null; then
    gum style --foreground 1 "Could not reach or authenticate with root@${TARGET_IP} over SSH."
    exit 1
fi

gum log --level info "Scanning disks on target..."
mapfile -t DISK_LINES < <(ssh "root@${TARGET_IP}" lsblk -dbno NAME,SIZE,MODEL)
if [[ ${#DISK_LINES[@]} -eq 0 ]]; then
    gum style --foreground 1 "No disks detected on target."
    exit 1
fi
if [[ ${#DISK_LINES[@]} -eq 1 ]]; then
    SELECTED_DISK_LINE="${DISK_LINES[0]}"
else
    SELECTED_DISK_LINE="$(gum choose --header "Select the install disk:" "${DISK_LINES[@]}")"
fi
if [[ -z "$SELECTED_DISK_LINE" ]]; then
    gum style --foreground 1 "A disk needs to be selected."
    exit 1
fi

DISK_NAME="$(awk '{print $1}' <<< "$SELECTED_DISK_LINE")"

DISK_SIZE_BYTES="$(awk '{print $2}' <<< "$SELECTED_DISK_LINE")"

DISK_DEVICE="/dev/${DISK_NAME}"

MIN_REQUIRED_BYTES=$(( (1 + 512) * 1024 * 1024 + 4 * 1024 * 1024 * 1024 ))
if (( DISK_SIZE_BYTES < MIN_REQUIRED_BYTES )); then
    gum style --foreground 1 "Disk '$DISK_DEVICE' is too small for the default disko layout."
    gum style --foreground 1 "Write a custom disko.nix for this host instead."
    exit 1
fi


# -------------------- Show summary --------------------

gum style --bold "Provisioning configuration"
gum style --border rounded --padding "0 1 0 1" \
"Host:              | $HOSTNAME_INPUT" \
"Target IP:         | $TARGET_IP" \
"Disk Name:         | $DISK_NAME" \
"Disk Size (bytes): | $DISK_SIZE_BYTES" \
"Disk Device:       | $DISK_DEVICE"

gum style --foreground 3 "This will generate a host key, rekey secrets, WIPE '$DISK_DEVICE' on $TARGET_IP, and install NixOS with this config."
if ! gum confirm "Proceed with provisioning?"; then
    gum style --foreground 3 "Cancelled."
    exit 0
fi



# -------------------- Ajust config --------------------

gum log --level info "Changing disk device in disko.nix to ${DISK_DEVICE}."
sed -i "s|/dev/CHANGE_ME|$DISK_DEVICE|g" "$DISKO_FILE"

TMP_KEY_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_KEY_DIR"' EXIT

HOST_KEY_PATH="$TMP_KEY_DIR/id_ed25519"
gum log --level info "Generating SSH keypair for ${HOSTNAME_INPUT}..."
ssh-keygen -t ed25519 -f "$HOST_KEY_PATH" -N "" -C "$HOSTNAME_INPUT" >/dev/null

HOST_PUBKEY="$(cat "${HOST_KEY_PATH}.pub")"

if grep -Fq "  ${HOSTNAME_INPUT} =" "$KEYS_DATA"; then
    gum style --foreground 1 "An entry for '$HOSTNAME_INPUT' already exists in $KEYS_DATA."
    exit 1
fi
gum log --level info "Appending public key to $KEYS_DATA"
KEY_DECL="  ${HOSTNAME_INPUT} = \"${HOST_PUBKEY}\";"
awk -v declaration="$KEY_DECL" '
    /^}/ {
        print declaration
    }
    { print }
' "$KEYS_DATA" > "$KEYS_DATA.tmp"
mv "$KEYS_DATA.tmp" "$KEYS_DATA"

gum log --level info "Rekeying secrets to include ${HOSTNAME_INPUT}..."
(
    cd "$SECRETS_DIR"
    agenix -r
)

gum log --level info "All staged files will be included on the newly provisioned host."
if gum confirm "Review/adjust staged files in lazygit before proceeding?"; then
    lazygit -p "$REPO_ROOT"
fi

gum log --level info "Verifying required files are staged..."
REQUIRED_STAGED=(
    "hosts/$HOSTNAME_INPUT/disko.nix"
    "secrets/keys-data.nix"
)
mapfile -t CHANGED_SECRET_FILES < <(git -C "$REPO_ROOT" status --porcelain -- secrets/ | awk '{print $2}')
REQUIRED_STAGED+=("${CHANGED_SECRET_FILES[@]}")
MISSING_STAGED=()
for f in "${REQUIRED_STAGED[@]}"; do
    if ! git -C "$REPO_ROOT" diff --cached --name-only | grep -Fxq "$f"; then
        MISSING_STAGED+=("$f")
    fi
done
if [[ ${#MISSING_STAGED[@]} -gt 0 ]]; then
    gum style --foreground 1 "The following required files are not staged: ${MISSING_STAGED[*]}"
    exit 1
fi


# -------------------- Deploy --------------------

INSTALLER_HOST_KEY="$(
    ssh-keyscan -T 5 -t ed25519 "$TARGET_IP" 2>/dev/null |
        awk 'NR == 1 { print $2 " " $3 }'
)"

EXTRA_FILES_DIR="$TMP_KEY_DIR/extra-files"
mkdir -p "$EXTRA_FILES_DIR/home/flottegurke/.ssh"
cp "$HOST_KEY_PATH" "$EXTRA_FILES_DIR/home/flottegurke/.ssh/id_ed25519"
cp "${HOST_KEY_PATH}.pub" "$EXTRA_FILES_DIR/home/flottegurke/.ssh/id_ed25519.pub"
chmod 700 "$EXTRA_FILES_DIR/home/flottegurke/.ssh"
chmod 600 "$EXTRA_FILES_DIR/home/flottegurke/.ssh/id_ed25519"
chmod 644 "$EXTRA_FILES_DIR/home/flottegurke/.ssh/id_ed25519.pub"

gum log --level info "Running nixos-anywhere..."
nix run github:nix-community/nixos-anywhere -- --flake "$REPO_ROOT#$HOSTNAME_INPUT" --extra-files "$EXTRA_FILES_DIR" --chown /home/flottegurke/.ssh 1000:100 --generate-hardware-config nixos-generate-config "$HOST_DIR/hardware-configuration.nix" "root@${TARGET_IP}"


# -------------------- Review & stage --------------------

gum style --border rounded --padding "1 2" --bold --foreground 2 "Host '$HOSTNAME_INPUT' provisioned successfully!"

if gum confirm "Show diff of changes?"; then
    {
        git -C "$REPO_ROOT" -c color.diff=always diff --color=always

        while IFS= read -r -d '' f; do
            git -C "$REPO_ROOT" -c color.diff=always diff --no-index --color=always /dev/null "$f" || true
        done < <(git -C "$REPO_ROOT" ls-files --others --exclude-standard -z)
    } | gum pager
fi

if gum confirm "Stage all changes with 'git add .'?"; then
    git -C "$REPO_ROOT" add .
    gum style --foreground 2 "Changes staged."
else
    gum style --foreground 3 "Skipped staging. Run 'git add' manually when ready."
fi

gum style --faint "Next step: log into the machine and run config-postinstall-host."
