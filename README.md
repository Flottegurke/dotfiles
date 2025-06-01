# dotfiles
This repo contains dotfiles for a minimalist [Hyprland](https://hyprland.org/) setup, which can be applyed using [GNU Stow](https://www.gnu.org/software/stow/).

## OS - Setup
Since I am using Arch, you can check out the [OS setup README](https://github.com/Flottegurke/dotfiles/blob/main/OsSetupReadme.md) for a short description on how to set it up.
> [!NOTE]
> I do not suggest, that you install arch by following this guide if you have never donne it before, since arch is about doing things yourself, and not relying on rigit instructoins, so you likely won't come verry faar. This guide is primarily for me, to be able to setup arch on new machines, the exact same way it is installed on my other machines.
> 
> The dotfiles are not arch specific, but if your distro is using a package mannager other then pacman (an additionally yay) you may will not be able to install all the programms that are used. 



## OS - Configuration
This is a short explenation on how to apply the dotfiles, and further optimise the PC.
> [!NOTE]
> I know, that just writing a bash file would have been easyer for everyone, but i diden't do it (sorry)  


### 1. GRUB optimisations
To not have to wait 5 seconds for grub to autostart Arch, you can change the timeout by edditing the grub configuration file (`sudo nano /etc/default/grub`) and setting the `GRUB_TIMEOUT` to something like `2` seconds.

Then type `sudo grub-mkconfig -o /boot/grub/grub.cfg` to reload the grub coniguration

### 2. Installing Hyprland
Install Hyprland by executing: `sudo pacman -S hyprland`.

It is bennefitial to instal the terminal emulator and programm louncher this config is using, before using hyprland to procced:
```shell
sudo pacman -S kitty rofi
```
Now in the hyprland config file (`~/.config/hypr/hyprland.conf`) change this line: `$menu = wofi --show drun` to this:
```shell
$menu = rofi -show drun
```
You can now use hyprland to proced with the setup.


### 3. cloning dotfiles and installing stow
Before we can start customising the new installation further, we should download stow and the dotfiles.

For this we should firstly setup git.
> [!NOTE]
>  This is ownly important for people that want to be able to push into the dotfiles directory, so if you do not want to, just execute `git clone https://github.com/Flottegurke/dotfiles` and skip the rest of the git setup steps.

#### Seting up Git
To setup git, execute:
```shell
sudo pacman -S git
git config --global user.name "<yourUsername>"
git config --global user.email "<your.email@example.com>"
``` 
If you have not already donne sow, create a ssh.key like this:
```shell
ssh-keygen -t ed25519 -C "<your_email@example.com>"
```
And then add it in your github account under `Settings/SSh and GPT keys`


Now, you can finaly clone the git repo:
```shell
cd ~/.config
git clone git@github.com:Flottegurke/dotfiles.git
```
> [!IMPORTANT]
> It is inportant to ownly clone the dotfiles repo into the `~/.onfig` folder.
> `stow` won't use the right target root directory if this is not donne.

#### Installing stow
After that, i think it is time to install stow: `sudo pacman -S stow`

### 4. installing utility programms
Now is a good time to install all kinds of utility programms, which some other programms and shortcuts need to function, especially all [utility programms, which need no additionally configuration](https://github.com/Flottegurke/dotfiles/blob/main/ProgrammsREADME.md#utility-programms-which-need-no-additionally-configuration). 
I suggest you go throug all of these programms mannualy and resolve anny errors that might appear.


### 5. Applying hyprland dotfiles
1. To apply the hyprland config, the old one needs to get remooved first: `rm ~/.config/hypr/hyprland.conf`
2. Now, make shure the `/hyp` directory is completly empty: `ls ~/.config/hypr/`-
3. Now, the hyprland dotfiles can be imported: `stow hyprland` and `stow hyprmocha`
> [!NOTE]
>  all `stow` commands need to get executed in the root directory of the `dotfiles` repo:
> ```shell
> cd ~/.config/dotfiles
> ```
4. finnaly, add execution permissions to the custom script: `sudo chmod +x ~/.config/hypr/scripts/handleMonitorConnect.sh`


### 6. Display manager customisation
Instead of using `gdm` (the default GNOME welcome screen) i want to use [ly](https://github.com/fairyglade/ly). Changing the Displax mannager can be done like this:
1. install ly: `sudo pacman -S ly`
2. uninstall gdm: `sudo pacman -Rns gdm`
3. enable ly: `sudo systemctl enable ly.service`
4. remove old configuration file: `sudo rm /etc/ly/config.ini`
5. add preconfigured file from dotfiles repo: `sudo stow --target=/etc ly`
6. open `/etc/pam.d/login` and add
   ```shell
   auth       optional     pam_gnome_keyring.so
   session    optional     pam_gnome_keyring.so auto_start
   ```
   this will unlock keyring automaticaly on bootup.
8. if you now reload the Display Menager, you should see the custom config: `sudo systemctl reload ly.service`


### 7. setting up notifications
1. install notification mannager: `sudo pacman -S swaync`
2. apply configuration: `stow swaync`


### 8. Setting up the console (kitty)
#### 1. Styling
   1. Start by removing the auto generated `.bashrc` file: `sudo rm ~/.bashrc`
   2. Then apply the custom bash dotfiles: `sudo stow -t ~ bash`
   3. contignue  by downloading starship: `sudo pacman -S starship`.
   4. Then just stow the config files for kitty `stow kitty` and for starship `stow starship`.
   5. now, install bat (`sudo pacman -S bat`), fzf (`sudo pacman -S fzf`) and zoxide (`sudo pacman -S zoxide`)
   6. finally, source the `.bashrc` file: `source ~/.bashrc`


### 9. Setting up waybar
   1. firstly, install waybar: `sudo pacman -S waybar`
   3. then, apply the dotfiles: `stow waybar`
   4. change permissions for custom scripts: `chmod +x .config/waybar/scripts/CustomNetworkData.sh` and `chmod + x .config/waybar/scripts/CombinedTemperature.sh`


### 10. Setting up hyprlock
   1. install hyprlock `sudo pacman -S hyprlock`
   2. chreate config file simlink: `stow hyprlock`


### 11. Configuring hypridle
   1. install `hpridle`: `sudo pacman -S hypridle`
   2. apply dotfiles: `stow hypridle`
   3. make custom scripts executable: `~/.config/hypr/dimScreen75Percent.sh`


### 12. Styling gnome apps
   1. make shure, you installed the `catppuccin-gtk-theme-mocha-revamped` theme from the [Utility programs which do no trquire setup](https://github.com/Flottegurke/dotfiles/blob/main/ProgrammsReadme.md#utility-programms-which-need-no-additionally-configuration) list.#
   2. install `nwg-look`: `sudo pacman -S nwg-look`
   3. open the app (for example by executing `nwg-look` in the terminal
   4. choose the theme you like the most (I choose `catppuccin-mocha-sapphire-standard+default`)
   5. choose the font you like (choose `CaskaydiaCove Nerd Font Regular 11`)
   6. choose color scheme: `prefer dark`
   7. klick `apply` and `exit`


### 13. Styling rofi (application runner)
   1. chreate simlinks: `stow rofi`
   2. install `rofi-emoji` and `rofi-calc`

### 14. Setting up immage to text (ocr)
   1. install tesseract: `sudo pacman -S tesseract`
   2. make shure all 3 language datasets (English, German, French) are correctly installed: `tesseract --list-langs`
   3. change customScript permissions: `sudo chmod +x ~/.config/hypr/scripts/ocrClipboard.sh` 


### 15. Installing additoinal programms
Now you can install all the other programms you need, for inspiration, have a look at the [additional programms list](https://github.com/Flottegurke/dotfiles/blob/main/ProgrammsReadme.md#general-programms)

> [!NOTE]
> For brave do not forget to add your vavourite plugins, like: `Proton Pass`,  `SponsorBlock` and `Youtube Custom Speed`  




## Keybindings
This is a short overview over all Hyprland shortcuts, this does not include programm specific shortcuts
> [!WARNING]
> All keybindings specifyed below will be "catched" by Hyprland, and prevented from reaching the programm. If this is a Issue, passthroughs can be setup

### Main mod
the main modifyer can be set at the top of the Keybindings file, per default it is set to the `super`/`windows` key.

Every keybinding starts with the main modifyer, it is just not listed for improoved readability


### Programm louch bindings
| key | action |
|-----|--------|
| Q | Terminal (kitty) |
| E | fileManager (nautilus) |
| P | Menu (rofi) |
| B | Browser (brave) |

### Utility bindings
| key | action |
|-----|--------|
| shift + C | color picker |
| shift + W | screenshot window (can be selected) |
| shift + A | screenshot active window |
| shift + E | screenshot region (can be selected) |
| shift + T | coppy text from selected regin (using optical caracter recognition) |
| shift + R | screen recording |
| V | Clipboard history |
| . | emoji selector |
| C | calculator (a popup NOT the app) |
| N | toggle notification hub |
| shift + n | toggle DnD |
| D | close latest notificarion (ownly works if the notificaiton is still displayed on screen, not in the hub) |
| shift + D | close all notifications |


### Power bindins
| key | action |
|-----|--------|
| controll + S | shutdown |
| controll + R | reboot |
| controll + Q | lock |
| controll + O | turn on dpms (backlight) (this is a faalback if ti does not turn on automatically) |
| controll + E | exit (logout) |

### General (window bindings)
| key | action |
|-----|--------|
| O | kill active window |
| F | toffle Floating (window) |
| R | toggle pseudo |
| T | toggle split (direction) |
| I | Pin window (and toggle floating) |
#### Group bindings
| key | action |
|-----|--------|
| G | toggle group |
| tab | change active group window -> forward |
| shift + tab | change active group window -> backward |
#### Move focus
| key | action |
|-----|--------|
| H | change active window | Left |
| J | change active window -> Down |
| K | change active window -> Up |
| L | change active window -> Right |
#### Swap windows
| key | action |
|-----|--------|
| controll + H | change active window -> Left |
| controll + J | change active window -> Down |
| controll K | change active window -> Up |
| controll + L | change active window -> Right |
#### Resize windows
| key | action |
|-----|--------|
| shift + H | change active window -> Left |
| shift + J | change active window -> Down |
| shift K | change active window -> Up |
| shift + L | change active window -> Right |
#### Mouse binds
| key | action |
|-----|--------|
| leftMouseKlick | move window |
| rightMouseKlick | resice window |
#### Switching workspaces
| key | action |
|-----|--------|
| 1 | focus workspace 1 |
| 2 | focus workspace 2 |
| 3 | focus workspace 3 |
| 4 | focus workspace 4 |
| 5 | focus workspace 5 |
| 6 | focus workspace 6 |
| 7 | focus workspace 7 |
| 1 | focus workspace 8 |
| 9 | focus workspace 9 |
| 0 | focus workspace 10 |
#### Move active window to workspace
| key | action |
|-----|--------|
| shift + 1 | move (active) window to workspace 1 |
| shift + 2 | move (active) window to workspace 2 |
| shift + 3 | move (active) window to workspace 3 |
| shift + 4 | move (active) window to workspace 4 |
| shift + 5 | move (active) window to workspace 5 |
| shift + 6 | move (active) window to workspace 6 |
| shift + 7 | move (active) window to workspace 7 |
| shift + 1 | move (active) window to workspace 8 |
| shift + 9 | move (active) window to workspace 9 |
| shift + 0 | move (active) window to workspace 10 |
#### move active workspace to monitor
| key | action |
|-----|--------|
| controll + 1 | move (active) window to workspace 0 |
| controll + 2 | move (active) window to workspace 1 |
| controll + 3 | move (active) window to workspace 2 |
| controll + 4 | move (active) window to workspace 3 |
| controll + 5 | move (active) window to workspace 4 |
| controll + 6 | move (active) window to workspace 5 |
| controll + 7 | move (active) window to workspace 6 |
| controll + 1 | move (active) window to workspace 7 |
| controll + 9 | move (active) window to workspace 8 |
| controll + 0 | move (active) window to workspace 9 |
#### spetial workspace
| key | action |
|-----|--------|
| S | toggle spetial workspace |
| shift + S | move (active) window to workspace |

### FN-key bindings
| key | action |
|-----|--------|
| raiseVolume | raise volume |
| lowerVolume | lower volume |
| muteAudio | mute audio |
| muteMic | mute mic |
| brightnesUp | brightnes up |
| brightnesDown | brightnes down |
| mediaNext | next reack |
| mediaPrev | previous track |
| mediaPause | pause |
| mediaPlay | play |
