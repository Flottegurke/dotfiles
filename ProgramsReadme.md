# ProgramsReadme
This is a file with all program i reccomend installing

## Utility Programs
These programs provides some quallity of live improovements, for example by allowing color picking from the screen.

### Utility programs which need no additionally configuration 
| Name | Installer | description | web-app | wayland/x11 |
|------|-----------|-------------|---------|-------------|
| yay | pacman (yay) | unoffition package downloader | - | - |
| playerctl | pacman (playerctl) | used to controll media playing via cli (and the function keys due to keybindings) | - | - |
| wl-clipboard | pacman (wl-clipboard) | provides clipboard acces to the cli | - | - |
| hyprpicker| pacman (hyprpickeer) requires: pacman (wl-clipboard) | used to pic colours from the screen | no | wayland |
| xdg-desktop-portal-hyprland-git | yay (xdg-desktop-portal-hyprland-git) | lets other applications communicate with the compositor through D-Bus | - | wayland |
| hyprland-qt-support | pacman (hyprland-qt-support) | fixes the behaviour of QT based programs | no | wayland |
| hyprland-qtutils | pacman (hyprland-qtutils) | additional qt fixes and qt-popup styling | - | wayland |
| qt6-wayland | pacman (qt6-wayland) | runns qt6 apps on wayland | - | wayland |
| qt5-wayland | pacman (qt5-wayland) | runns qt5 apps on wayland | - | wayland |
| hyprshot | yay (hyprshot) | program to take screenshots | no | wayland |
|	brightnessctl | pacman (brightnessctl) | used to change displax brightnes on the CLI | - | - |
| hyprpolkitagent | pacman (hyprpolkitagent) | used by GUI programs to ask for root privileges | no | wayland |
| ttf-cascadia nerd fond | pacman (ttf-cascadia-code-nerd) | used by starship for icons | - | - |
| stow | pacman (stow) | used to chreate and mannage simlinking files (usually for dotfiles) | - | - |
| pavucontrol | pacman (pavucontrol) | used to controll the audio via a GUI | no | wayland |
| hyprgraphics | pacman (hyprgraphics) | enables finer controll over graphics | - | - |
| nmtui | pacman (networkmanager) | provids a TUI for network mannagement | - | - |
| cliphist | pacman (cliphist) | provides a clipboard hostory and preview | - | - |
| overskride | yay (overskride) | bluetooth mannager UI | - | - |
| udiskie  | pacman (udiskie) | used to enable storrage mounting via cli (automaunts all disks) | - | - |
| catppuccin-gtk-theme-mocha-revamped | yay (catppuccin-gtk-theme-mocha-revamped) | catppuccin theme for gnome apps | - | wayland |
| wtype | pacman (wtype) | used to simulate keyboard inputs (for example: insert emojis) | - | wayland |
| kooha | pacman (kooha) | screen recorder | no | wayland |
| dnsmasq | pacman (dnsmasq) | handles various DNS tasks | - | - |
| wihotspot | yay (linux-wifi-hotspot-bin) requires: dnsmasq | GUI for creating hotspots | no | wayland |
| tesseract-data-eng | pacman (tesseract-data-eng) | tesseract english language dataset | - | - |
| tesseract-data-deu | pacman (tesseract-data-deu) | tesseract german language dataset | - | - |
| tesseract-data-fra | pacman (tesseract-data-fra) | tesseract french language dataset | - | - |
| socat | pacman (socat) | port utility (functions and listeners) | - | - |


### Utility programs which need additionally configuration 
| Name | Installer | description | web-app | wayland/x11 |
|------|-----------|-------------|---------|-------------|
| ly | pacman (ly) | Display Manager (connonly known as Login mannager, or Welcome screen) | no | wayland |
| swaync | pacman (swaync) | Notification mannager | no | x11 |
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
| rofi-emoji | pacman (rofi-emoji) requires: wtype | rofi extension to select emojis | - | - |
| rofi-calc | pacan (rofi-calc) | rofi extension to perofrm calculations | - | - |
| tesseract | pacman (tesseract) | cli tool for immage to text (ocd) converison | - | - |


## General programs
| Name | Installer | description | web-app | wayland/x11 |
|------|-----------|-------------|---------|-------------|
| brave-bin | yay (brave-bin) | browser | no | x11 |
| kdenlive | pacman (kdenlive) | video editor | no | wayland |
| thunderbird | pacman (thunderbird) | Mail mamnager | no | -- | 
| gimp | pacman (gimp) | immage editor | no | wayland |
| discord | pacman (discord) | chat program | no | wayland |
| btop | pacman (btop) | resource monitor (tui) | - | - |
| intellij-idea-ultimate-edition | yay (intellij-idea-ultimate-edition)  | IDE | no | wayland |
| signal-desktop | pacman (signal-desktop) | chat program | no | wayland |
| tidal-hifi | yay (tidal-hifi) | music player | no | wayland |
| neofetch | yay (neofetch) | used to display basic system information | - | - |
| Microsoft teams (Work edition) | yay (teams-for-linux-bin) | messanger (for companys) | no | wayland |
| asciiquarium | pacman (asciiquarium) | verry important | - | - |
| xmind | yay (xmind) | mindmap chreation tool | no | wayland | 
| lazygit | pacman (lazygit) | TUI for git | - | - |
| lazydocker | yay (lazydocker) | TUI for docker | - | - |
| arduino-ide | pacman (arduino-ide) | IDE for Arduinos | no | wayland |
| Raspberry Pi imager | pacman (rpi-imager) | Raspberry Pi image creation tool | no | wayland |
| Postman | yay (postman-bin) | API platform (testing) | yes | wayland | 
| slack | yay (slack-desktop-wayland) | comminocaitno platform | no | wayland |
| blender | pacman (blender) | 3D graphics chreation suite | no | wayland |
| bottles | yay (bottles) | GUI for runnign windows peogramms | no | wayland |
| virtualbox | pacman (virtualbox) | VM engine | no | wayland |
| mousai | pacman (mousai) | song recognition software | no | wayland |

## Windows programms
These are the programms, that i was not able to get runnign on linux.

To runnwindows programms i am using a VM. for further explenation about the setup see the [windows-VM setup readme](). 
| Name | Installer | description |
|------|-----------|-------------|
| win-debloat-tools | [github](https://github.com/LeDragoX/Win-Debloat-Tools) | script to debloat windows |
| Onenote | [onenote.com](https://www.onenote.com/?public=1&wdorigin=ondcauth2&wdorigin=ondc) | Note taking programm
