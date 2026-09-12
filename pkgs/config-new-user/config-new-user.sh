#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$HOME/.config/dotfiles"
USERS_DIR="$REPO_ROOT/users"
SECRETS_DIR="$REPO_ROOT/secrets"
SECRETS_NIX="$SECRETS_DIR/secrets.nix"


header=$(gum style --border rounded --padding "1 2" --margin "5 2 1 2" --bold "Create a new NixOS user")
description=$(gum style --padding "0 0 5 0" --faint "This will create the user configuration and password secret for a new user")
gum join --vertical --align center "$header" "$description"


# -------------------- Collect user information --------------------

USERNAME="$(gum input --placeholder "username" --prompt "Username: ")"
if [[ -z "$USERNAME" ]]; then
    gum style --foreground 1 "Username cannot be empty."
    exit 1
fi
if [[ ! "$USERNAME" =~ ^[a-z_][a-z0-9_-]*$ ]]; then
    gum style --foreground 1 "Invalid username. Use lowercase letters, numbers, '_' or '-'."
    exit 1
fi

USER_DIR="$USERS_DIR/$USERNAME"
if [[ -e "$USER_DIR" ]]; then
    gum style --foreground 1 "Userdir '$USER_DIR' already exists."
    exit 1
fi

PASSWORD_SECRET="$SECRETS_DIR/users-${USERNAME}-password.age"
if [[ -e "$PASSWORD_SECRET" ]]; then
    gum style --foreground 1 "Password secret `$PASSWORD_SECRET` already exists."
    exit 1
fi

DESCRIPTION="$(gum input --placeholder "Friendly Name" --prompt "Description: ")"

SHELL_NAME="$(gum choose --header "Default shell:" "bash" "zsh" "fish")"
case "$SHELL_NAME" in
    bash)
        SHELL_EXPR='pkgs.bashInteractive'
        ;;
    zsh)
        SHELL_EXPR='pkgs.zsh'
        ;;
    fish)
        SHELL_EXPR='pkgs.fish'
esac

EXTRA_GROUPS=$(gum choose --no-limit --header "Additional groups:" "wheel" "networkmanager" "audio" "video" "docker" "libvirtd")

SECRET_GROUP="$(gum choose --header "Which machines should be able to decrypt this user's password?" "allMachines" "allDesktops" "allWorkMachines" "allAdminMachines")"

if gum confirm "Create Home manager configuration?"; then
    HOME_MANAGER=true
else
    HOME_MANAGER=false
fi

# -------------------- Show summary --------------------

EXTRA_GROUPS_DISPLAY="${EXTRA_GROUPS//$'\n'/, }"

gum style --bold "User configuration"
gum style --border rounded --padding "0 1 0 1" \
"Username:     | $USERNAME" \
"Description:  | $DESCRIPTION" \
"Shell:        | $SHELL_NAME" \
"Groups:       | ${EXTRA_GROUPS//$'\n'/, }" \
"Home Manager: | $([[ "$HOME_MANAGER" == true ]] && echo yes || echo no)" \
"Secret group: | $SECRET_GROUP"

if ! gum confirm "Create this user?"; then
   gum style --foreground 3 "Cancelled."
   exit 0
fi


# -------------------- Password --------------------

PASSWORD="$(gum input --password --placeholder "password" --prompt "Password: ")"
if [[ -z "$PASSWORD" ]]; then
    gum style --foreground 1 "Password cannot be empty."
    exit 1
fi

PASSWORD_CONFIRM="$(gum input --password --placeholder "password" --prompt "Confirm password: ")"
if [[ "$PASSWORD" != "$PASSWORD_CONFIRM" ]]; then
    gum style --foreground 1 "Passwords do not match."
    exit 1
fi

PASSWORD_HASH="$(printf '%s\n' "$PASSWORD" | mkpasswd -m yescrypt --stdin)"

unset PASSWORD PASSWORD_CONFIRM


# -------------------- Applying config --------------------

gum log --level info "Appending Secret to $SECRETS_NIX."
SECRET_DECL="  \"users-${USERNAME}-password.age\".publicKeys = keys.${SECRET_GROUP};"
if grep -Fq "\"users-${USERNAME}-password.age\"" "$SECRETS_NIX"; then
    gum style --foreground 1 "A secret entry for $USERNAME already exists."
    exit 1
fi
awk -v declaration="$SECRET_DECL" '
    /^}/ {
        print declaration
    }
    { print }
' "$SECRETS_NIX" > "$SECRETS_NIX.tmp"
mv "$SECRETS_NIX.tmp" "$SECRETS_NIX"
gum log --level warn "Every machine in '${SECRET_GROUP}' will be able to decrypt this user's password!"

gum log --level info "Encrypting pasword hash with agenix."
TMP_SECRET="$(mktemp)"
printf '%s\n' "$PASSWORD_HASH" > "$TMP_SECRET"
unset PASSWORD_HASH
SECRET_FILENAME="users-${USERNAME}-password.age"
(
    cd "$SECRETS_DIR"
    RULES="./secrets.nix" agenix -e "$SECRET_FILENAME" < "$TMP_SECRET"
)
rm -f "$TMP_SECRET"

readarray -t EXTRA_GROUPS_ARR <<< "$EXTRA_GROUPS"
EXTRA_GROUPS_ARR=($(printf '%s\n' "${EXTRA_GROUPS_ARR[@]}" | grep -v '^$'))
GROUPS_NIX=""
if (( ${#EXTRA_GROUPS_ARR[@]} > 0 )); then
    GROUPS_NIX="extraGroups = [ $(printf '"%s" ' "${EXTRA_GROUPS_ARR[@]}") ];"
fi

gum log --level info "Generating ${USER_DIR}"
mkdir -p "$USER_DIR"

gum log --level info "Generating ${USER_DIR}/secrets.nix"
cat > "$USER_DIR/default.nix" <<EOF
{ pkgs, config, ... }:
{
  description = "$(printf '%s' "$DESCRIPTION" | sed 's/"/\\"/g')";
  # The \`users-${USERNAME}-password\` secret is used as the user password.
  isNormalUser = true;
  group = "users";
  shell = $SHELL_EXPR;
  $GROUPS_NIX
}
EOF

if [[ "$HOME_MANAGER" == true ]]; then
    gum log --level info "Generating ${USER_DIR}/home.nix"
    cat > "$USER_DIR/home.nix" <<EOF
{ config, pkgs, ... }:
{
  home.stateVersion = "26.05";

  home.packages = [
  ];
}
EOF
fi


# -------------------- Review & stage --------------------

gum style --border rounded --padding "1 2" --bold --foreground 2 "User '$USERNAME' created successfully!"

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

gum style --faint "Next steps: review wich host should have access to the user-secret / enable the user / rebuild the system."
