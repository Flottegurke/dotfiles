#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$HOME/.config/dotfiles"
HOSTS_DIR="$REPO_ROOT/hosts"
ROLES_DIR="$REPO_ROOT/roles"
USERS_DIR="$REPO_ROOT/users"


header=$(gum style --border rounded --padding "1 2" --margin "5 2 1 2" --bold "Create a new NixOS host")
description=$(gum style --padding "0 0 5 0" --faint "This will create a new host config under hosts/")
gum join --vertical --align center "$header" "$description"


# -------------------- Collect host information --------------------

HOSTNAME_INPUT="$(gum input --placeholder "hostname" --prompt "Hostname: ")"
if [[ -z "$HOSTNAME_INPUT" ]]; then
    gum style --foreground 1 "Hostname cannot be empty."
    exit 1
fi
if [[ ! "$HOSTNAME_INPUT" =~ ^[a-z0-9][a-z0-9-]*$ ]]; then
    gum style --foreground 1 "Invalid hostname. Use lowercase letters, numbers, or '-'."
    exit 1
fi

HOST_DIR="$HOSTS_DIR/$HOSTNAME_INPUT"
if [[ -e "$HOST_DIR" ]]; then
    gum style --foreground 1 "Host directory '$HOST_DIR' already exists."
    exit 1
fi

PLATFORM="$(gum choose --header "Platform:" "x86_64-linux" "aarch64-linux")"

# discover available roles from roles/ (each subdirectory is one role)
mapfile -t AVAILABLE_ROLES < <(find "$ROLES_DIR" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort)
if [[ ${#AVAILABLE_ROLES[@]} -eq 0 ]]; then
    gum style --foreground 1 "No roles found under '$ROLES_DIR'."
    exit 1
fi
SELECTED_ROLES=$(gum choose --no-limit --header "Roles to enable:" "${AVAILABLE_ROLES[@]}")
if [[ -z "$SELECTED_ROLES" ]]; then
    gum style --foreground 1 "At least one role must be selected."
    exit 1
fi

# discover available users from users/ (each subdirectory is one user)
mapfile -t AVAILABLE_USERS < <(find "$USERS_DIR" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort)
SELECTED_USERS=""
if [[ ${#AVAILABLE_USERS[@]} -gt 0 ]]; then
    SELECTED_USERS=$(gum choose --no-limit --header "Users to enable on this host: (user: 'flottegurke' is always active)" "${AVAILABLE_USERS[@]}")
fi

SWAP_OVERRIDE=""
if gum confirm "Override the default swap size (8192 MB)?"; then
    SWAP_OVERRIDE="$(gum input --placeholder "swap size in MB" --prompt "Swap (MB): ")"
    if [[ ! "$SWAP_OVERRIDE" =~ ^[0-9]+$ ]]; then
        gum style --foreground 1 "Swap size must be a number."
        exit 1
    fi
fi

readarray -t ROLES_ARR <<< "$SELECTED_ROLES"

IS_DESKTOP=false
for role in "${ROLES_ARR[@]}"; do
    [[ "$role" == desktop-* ]] && IS_DESKTOP=true
done

IS_WORK=false
if gum confirm "Mark this host as a work machine (ajusts SSH access)?"; then
    IS_WORK=true
fi

IS_ADMIN=false
if gum confirm "Mark this host as an admin machine (grants fleet-wide SSH login)?"; then
    IS_ADMIN=true
fi

# -------------------- Show summary --------------------

ROLES_DISPLAY="${SELECTED_ROLES//$'\n'/, }"
USERS_DISPLAY="${SELECTED_USERS//$'\n'/, }"

gum style --bold "Host configuration"
gum style --border rounded --padding "0 1 0 1" \
"Hostname:       | $HOSTNAME_INPUT" \
"Platform:       | $PLATFORM" \
"Roles:          | $ROLES_DISPLAY" \
"Users:          | ${USERS_DISPLAY:-none}" \
"Swap:           | ${SWAP_OVERRIDE:-default (8192MB)}" \
"SSH DektopRole: | $([[ "$IS_DESKTOP" == true ]] && echo yes || echo no)" \
"SSH WorkRole:   | $([[ "$IS_WORK" == true ]] && echo yes || echo no)" \
"SSH AdminRole:  | $([[ "$IS_ADMIN" == true ]] && echo yes || echo no)" 

if ! gum confirm "Create this host?"; then
    gum style --foreground 3 "Cancelled."
    exit 0
fi


# -------------------- Generate default.nix --------------------

gum log --level info "Generating ${HOST_DIR}"
mkdir -p "$HOST_DIR"

ROLES_NIX=""
for role in "${ROLES_ARR[@]}"; do
    [[ -z "$role" ]] && continue
    ROLES_NIX+="    roles-config.${role}.enable = true;
"
done

USERS_NIX=""
if [[ -n "$SELECTED_USERS" ]]; then
    readarray -t USERS_ARR <<< "$SELECTED_USERS"
    for user in "${USERS_ARR[@]}"; do
        [[ -z "$user" ]] && continue
        USERS_NIX+="    users-config.${user}.enable = true;
"
    done
fi

SWAP_NIX=""
if [[ -n "$SWAP_OVERRIDE" ]]; then
    SWAP_NIX="   swapSizeMB = ${SWAP_OVERRIDE};"
fi

gum log --level info "Generating ${HOST_DIR}/default.nix"
cat > "$HOST_DIR/default.nix" <<EOF
{
  meta = {
    isDesktop = ${IS_DESKTOP};
    isWork = ${IS_WORK};
    isAdmin = ${IS_ADMIN};
  };

  module = { ... }:
  {
    networking.hostName = "$HOSTNAME_INPUT";
    nixpkgs.hostPlatform = "$PLATFORM";

$USERS_NIX
$ROLES_NIX
$SWAP_NIX
  };
}
EOF

gum log --level info "Generating ${HOST_DIR}/disko.nix"
cat > "$HOST_DIR/disko.nix" <<'EOF'
{
  disko.devices.disk.main = {
    device = "/dev/CHANGE_ME"; # verify the real device (lsblk) before provisioning
    type = "disk";
    content = {
      type = "gpt";
      partitions = {
        boot.size = "1M"; boot.type = "EF02";
        ESP = { size = "512M"; type = "EF00"; content = { type = "filesystem"; format = "vfat"; mountpoint = "/boot"; }; };
        root = { size = "100%"; content = { type = "filesystem"; format = "ext4"; mountpoint = "/"; }; };
      };
    };
  };
}
EOF
    gum log --level warn "disko.nix uses a placeholder device — edit it before provisioning this host."

gum log --level warn "hardware-configuration.nix was NOT generated. Produce it on the target machine (nixos-generate-config) and copy it into ${HOST_DIR}/."


# -------------------- Review & stage --------------------

gum style --border rounded --padding "1 2" --bold --foreground 2 "Host '$HOSTNAME_INPUT' scaffolded successfully!"

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

gum style --faint "Next steps: generate hardware-configuration.nix / fix disko.nix's device."
