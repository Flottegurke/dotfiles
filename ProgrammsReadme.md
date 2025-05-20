# ProgrammsReadme
This is a file with all programm i reccomend installing

## Utility Programms
These programms provides some quallity of live improovements, for example by allowing color picking from the screen.

### Utility programms which need no additionally configuration 
| Name | Installer | description | web-app | wayland/x11 |
|------|-----------|-------------|---------|-------------|
| playerctl | pacman (playerctl) | used to controll media playing via cli (and the function keys due to keybindings) | - | - |
| wl-clipboard | pacman (wl-clipboard) | provides clipboard acces to the cli | - | - |
| hyprpicker| pacman (hyprpickeer) requires: pacman (wl-clipboard) | used to pic colours from the screen | no | wayland |
| xdg-desktop-portal-hyprland | pacman (pacman xdg-desktop-portal-hyprland) | lets other applications communicate with the compositor through D-Bus | - | wayland |
| hyprland-qt-support | pacman (hyprland-qt-support) | fixes the behaviour of QT based programms | no | wayland |
| hyprland-qtutils | pacman (hyprland-qtutils) | additional qt fixes and qt-popup styling | - | wayland |
| qt6-wayland | pacman (qt6-wayland) | runns qt6 apps on wayland | - | wayland |
| qt5-wayland | pacman (qt5-wayland) | runns qt5 apps on wayland | - | wayland |
| hyprshot | yay (hyprshot) | programm to take screenshots | no | wayland |
|	brightnessctl | pacman(brightnessctl) | used to change displax brightnes on the CLI | - | - |
| Neofetch | pacman (neofetch) | used to display basic system information | - | - |
| swaync | pacman (swaync) | notofication deamon | no | wayland |
| hyprpolkitagent | pacman (hyprpolkitagent) | used by GUI programms to ask for root privileges | no | wayland |
| ttf-cascadia nerd fond | pacman (ttf-cascadia-code-nerd) | used by starship for icons | - | - |
| htop | pacman (htop) | used to moniitor system reyources is the cli  | - | - |
| stow | pacman (stow) | used to chreate and mannage simlinking files (usually for dotfiles) | - | - |
| pavucontrol | pacman (pavucontrol) | used to controll the audio via a GUI | no | wayland |
| hyprgraphics | pacman (hyprgraphics) | enables finer controll over graphics | - | - |
| nmtui | pacman (networkmanager) | provids a TUI for network mannagement | - | - |
| cliphist | pacman (cliphist) | provides a clipboard hostory and preview | - | - |
| Overskride | yay (overskride) | bluetooth mannager UI | - | - |
| udiskie  | pacman (udiskie) | used to enable storrage mounting via cli (automaunts all disks) | - | - |
| catppuccin-gtk-theme-mocha-revamped | yay (catppuccin-gtk-theme-mocha-revamped) | catppuccin theme for gnome apps | - | wayland |

### Utility programms which need additionally configuration 
| Name | Installer | description | web-app | wayland/x11 |
|------|-----------|-------------|---------|-------------|
| ly | pacman (ly) | Display Manager (connonly known as Login mannager, or Welcome screen) | no | wayland |
| kitty | pacman (kitty) | Console emmulator | no | wayland |
| starship | pacman (starship) | Used to style the promt of consoles | no | wayland |
| bat | pacman (bat) | used to display files (like cat but with syntax gihlighting + other cool stuf) | - | - |
| fzf | pacman (fzf) | used to search files in the CLI | - | - |
| zoxide | pacman (zoxide) | makes changing directorys easyer by weighting them | - | - |
| waybar | pacman (waybar) | the status bar | no | wayland |
| hyprlock | pacman (hyprlock) | used to lock the screen | no | wayland | 
| hypridle | pacman (hypridle) requires: pacman (hyprlock) | used to idel the screen after timeout with no activity | no | wayland |
| nwg-look | pacman (nwg-look) requires: yay (catppuccin-gtk-theme-mocha-revamped) | applyes custom styles gnome apps | no | wayland |
| rofi | pacman (rofi)| applicatino runner | no | wayland |
| rofi-emoji | pacman (rofi-emoji) | rofi extension to select emojis | - | - |
| rofi-calc | pacan (rofi-calc) | rofi extension to perofrm calculations | - | - |


## General programms
| Name | Installer | description | web-app | wayland/x11 |
|------|-----------|-------------|---------|-------------|
| Kdenlive | pacman (kdenlive) | no | wayland |
