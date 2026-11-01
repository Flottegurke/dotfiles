detect_brave() {
    command_exists brave
}

automatic_brave() {
    launch_program brave "brave://policy"
}

guide_brave() {
    gum style --border rounded --padding "1 2" \
        "Extensions:" \
        "1. Bitwarden: sign in." \
        "2. Stylus:" \
        "  - chrome-extension://clngdbkpkpeebahjckkjfobafhncgmne/manage.html -> Import:"\
        "~/.config/dotfiles/programs/brave/extensions/stylus.json"\
        "3. Unhook" \
        "  - Enable: Darkmode; Hide Home Feed; Redirect to Subscriptions; Hide Live Chat; Hide Fundraiser; Hide End Screen Feed; Hide End Screen Cards; Hide Shorts; Hide Merch, Tickets, Offers; Disable Autoplay" \
        "4. YouTube Custom Speed:" \
        "  - brave://extensions/?options=kmfcinojnfabkpndlgomnfjllgeppegb" \
        "  - Speed list: Add: 2.5; 3.5" \
        "  - Default speed: Select: Set to custom speed: 2.5" \
        "  - Next video speed: Restore to default speed" \
        "  - Sync between tabs: Only apply the change in current tab" \
        "5. SponsorBlock:" \
        "  - chrome-extension://mnjggcdmjocbbbhaepdhchncahnbgone/options/options.html#import" \
        "  - Import/Export All Options -> Load from file" \
        "~/.config/dotfiles/programs/brave/extensions/sponsorBlock.json"
}

cleanup_brave() {
    close_launched_program
}

register_program "brave" "Brave"
