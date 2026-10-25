#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$HOME/.config/dotfiles"
HOSTS_DIR="$REPO_ROOT/hosts"
SECRETS_DIR="$REPO_ROOT/secrets"
KEYS_DATA="$SECRETS_DIR/keys-data.nix"


header=$(gum style --border rounded --padding "1 2" --margin "5 2 1 2" --bold "Remove a NixOS host")
description=$(gum style --padding "0 0 5 0" --faint "This will remove a host from the configuration")
gum join --vertical --align center "$header" "$description"


# -------------------- Collect host information --------------------

mapfile -t AVAILABLE_HOSTS < <(find "$HOSTS_DIR" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort)
if [[ ${#AVAILABLE_HOSTS[@]} -eq 0 ]]; then
    gum style --foreground 1 "No hosts found under '$HOSTS_DIR'."
    exit 1
fi

HOSTNAME_INPUT="$(gum choose --header "Host to remove:" "${AVAILABLE_HOSTS[@]}")"
if [[ -z "$HOSTNAME_INPUT" ]]; then
    gum style --foreground 1 "A host needs to be selected."
    exit 1
fi

HOST_DIR="$HOSTS_DIR/$HOSTNAME_INPUT"
if [[ ! -d "$HOST_DIR" ]]; then
    gum style --foreground 1 "Host directory '$HOST_DIR' does not exist."
    exit 1
fi

HAS_KEY=false
if grep -Eq "^[[:space:]]*${HOSTNAME_INPUT}[[:space:]]*=" "$KEYS_DATA"; then
    HAS_KEY=true
fi

CURRENT_HOST="$(hostname)"
if [[ "$CURRENT_HOST" == "$HOSTNAME_INPUT" ]]; then
    gum style --foreground 1 "The chosen config is used by this machine. This machine can not delete it's own config."
    exit 1
fi


# -------------------- Show summary --------------------

gum style --bold "Host removal"
gum style --border rounded --padding "0 1 0 1" \
"Host:           | $HOSTNAME_INPUT" \
"Host directory: | hosts/$HOSTNAME_INPUT" \
"SSH key entry:  | $([[ "$HAS_KEY" == true ]] && echo yes || echo no)"
echo
gum style --foreground 3 -- \
"This will:" \
"- remove hosts/$HOSTNAME_INPUT" \
"- remove the host key from secrets/keys-data.nix" \
"- rekey agenix secrets without this host"

if ! gum confirm "Remove '$HOSTNAME_INPUT' from the configuration?"; then
    gum style --foreground 3 "Cancelled."
    exit 0
fi


# -------------------- Remove host --------------------

gum log --level info "Removing host directory..."
rm -rf -- "$HOST_DIR"

if [[ "$HAS_KEY" == true ]]; then
    gum log --level info "Removing public key from $KEYS_DATA..."
    awk -v host="$HOSTNAME_INPUT" '
        {
            line = $0
            sub(/^[[:space:]]*/, "", line)

            if (line ~ ("^" host "[[:space:]]*=")) {
                next
            }

            print
        }
    ' "$KEYS_DATA" > "$KEYS_DATA.tmp"
    mv "$KEYS_DATA.tmp" "$KEYS_DATA"
else
    gum log --level warn "No key entry for '$HOSTNAME_INPUT' found in $KEYS_DATA."
fi

gum log --level info "Rekeying secrets without ${HOSTNAME_INPUT}..."
(
    cd "$SECRETS_DIR"
    agenix -r
)


# -------------------- Review & stage --------------------

gum style --border rounded --padding "1 2" --bold --foreground 2 "Host '$HOSTNAME_INPUT' removed successfully!"

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

gum style --faint "Next step: review, commit and push the host removal."

