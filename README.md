# dotfiles
This repo contains dotfiles for a minimalist [Hyprland](https://hyprland.org/) setup, which can be applyed using [GNU Stow](https://www.gnu.org/software/stow/).

## OS - Setup
Since i am using Arch, you can check out the [OS setup README](https://github.com/Flottegurke/dotfiles/blob/main/OsSetupReadme.md) for a short description on how to set it up.
> [!NOTE]
> I do not suggest, that you install arch by following this guide, if you have never donne it before, since arch is about doing things yourself, and not relying on rigit instructoins, so you likely won't come verry faar. This guide is primarily for me, to be able to setup arch on new machines, the exact same way it is installed on my other machines.
> 
> The dotfiles are not arch specific, but if your distro is using another package mennager then pacman (an doptionally yay) you may will not be able to onstall all the programms that are used. 



## OS - Configuration
This is a short explenation on how to apply the dotfiles, and further optimise the PC.

### 1. GRUB optimisations
To not have to wait 5 seconds for grub to autostart Arch, you can change the timeout by edditing the grub configuration file (`sudo nano /etc/default/grub`) and setting the `GRUB_TIMEOUT` to somthing like `2` seconds.

Then type `sudo grub-mkconfig -o /boot/grub/grub.cfg` to reload the grub coniguration

### 2. Installing and lounching Hyprland
Install Hyprland by executing: `pacman -S hyprland`.

It is also bennefitial to also instal the default terminal emulator and programm louncher of hyprland:
```shell
pacman -S kitty wofi
```
Before proceeding, you can now log out, and log in, this time with HYPRLAND.


### 3. cloning dotfiles and installing stow
Before we can start customising the new installation further, we should download stow and the dotfiles.

For this we should firstly setup git.
> [!NOTE]
>  This is ownly important for people that want to be able to push into the dotfiles directory, so if you do not want to, just execute `git clone https://github.com/Flottegurke/dotfiles` and skip the rest of the git setup steps.

#### Seting up Git
To setup git, execute:
```shell
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
After that, i think it is time to install stow: `pacman -S stow`

### 4. installing utility programms
Now is a good time to install all kinds of utility programms, which some other programms and shortcuts need to function, especially all [utility programms, which need no additionally configuration](https://github.com/Flottegurke/dotfiles/blob/main/ProgrammsREADME.md#utility-programms-which-need-no-additionally-configuration). 
I suggest you go throug all of these programms mannualy and resolve anny errors that might appear.


### 5. Applying hyprland dotfiles
1. To apply the hyprland config, the old one needs to get semooved first: `rm ~/.config/hypr/hyprland.conf`
2. Now, make shure the `/hyp` directory is filly empty: `ls ~/.config/hypr/`-
3. Finnaly, the hyprland dotfiles can be imported: `stow hyprland`
> [!NOTE]
>  all `stow` command sneed to get executed in the root directory of the `dotfiles` repo:
> ```shell
> cd ~/.config/dotfiles
> ```


### 6. Display manager customisation
Instead of using `gdm` (the default GNOME welcome screen) i want to use [ly](https://github.com/fairyglade/ly). Changing the Displax mannager can be done like this:
1. install ly: `pacman -S ly`
2. uninstall gdm: `sudo pacman -Rns gdm`
3. enable ly: `sudo systemctl enable ly.service`
4. remove old configuration file: `sudo rm /etc/ly/config.ini`
5. add preconfigured file from dotfiles repo: `sudo stow --target=/etc ly`
6. if you now reload the Display Menager, you should see the custom config: `sudo systemctl reload ly.service`


### 7. Setting up the console (kitty)
#### 1. Styling
   1. Start of by downloading starship: `sudo pacman -S starship`.
   2. Then just stow the config files for kitty `stow kitty` and for starship `stow starship`.
   3. now you need to add `eval "$(starship init bash)"` into your `~/.bashrc` file.
   4. once you source the `~/.bashrc` file the new promt should appear: `source .bashrc`.
   5. also make shure you installed the 	ttf-cascadia-code nerd fonts, in step `5. installing utility programms`, otherwise, the symbols will look wired.
#### 2. Bat
   1. Now we are going to set up bat: `sudo pacman -S bat`
   2. then just `stow bat` to apply the custom config
#### 3. fzf
   1. download fzf: `pacman -S fzf`.
   2. inside the `.bashrc` file: add
      ```shell
      # Set up fzf key bindings and fuzzy completion
      eval "$(fzf --bash)"
      ```
   3. you can also chreate some usefull aliases loike this:
      ```shell
      alias fzf='fzf --preview="bat --color=always --line-range 0:500 {}"'
      alias fzfo='nano $(fzf)'
      ```
      to always search with preview,
   4. Finaly `source .bashrc` to apply the changes.
#### 4. zoxide
   1. download zoxide: `sudo pacman -S zoxide`
   2. add `eval "$(zoxide init --cmd cd bash)"` to the `.bashrc` file.
   5. source the `.bashrc` file: `source .bashrc`


### 8. Setting up waybar
   1. firstly, install waybar: `pacman -S waybar`.
   2. then remove the autogenerated config: `rm ~/.config/waybar/config`
   3. now, that dotfiles can be applyed: `stow waybar`
   4. change permissiiiions for custom scripts: `chmod +x .config/waybar/scripts/CustomNetworkData.sh` and `chmod + x .config/waybar/scripts/CombinedTemperature.sh`


### 9. Setting up hyprlock
   1. install hyprlock `sudo pacman -S hyprlock`
   2. chreate config file simlink: `stow hyprlock`
