# Windows virtual machine Setup
This is a short guide on how to set up a windows VM.
> [!WARNING]
>  This guide does not explain how to fix issues with thew VM.
> 
> Be carefull installing the kernel drivers if needed, you might break you system

## 1. Setup
1. install `virtualbox`: `sudo pacman -S virtualbox`
2. download a windows 11 ISO from [the official microsoft site](https://www.microsoft.com/de-de/software-download/windows11)
3. install kernel drivers if deeded

## 2. VM settings
The setup inside virtual box
1. Klick `new` 
2.  choose a name (for example: `windows11proVM`)
3.  select the ISO file
4.  Choose your prefered windows version (`windows 11 pro` is recomended)
5.  choose a password (this does not need to be secure but if you weant to use `windows hello` the password needs to be at least 4 caracters long (i always choose 4 spaces))
6.  enter you prodict key (if you do not have one, go to [the microsoft clien tactivation site](https://learn.microsoft.com/en-us/windows-server/get-started/kms-client-activation-keys?tabs=server2025%2Cwindows1110ltsc%2Cversion1803%2Cwindows81#windows-11-and-windows-10-semi-annual-channel). This will give you a key which does not activate windows)
7.  Select how mouch memory and how many CPU cores you want to allow the Vm to use
8.  klick `next`

## 3. Windows settings
Some settings to make windows more light weight.

1. intsall the system and keyboard languages you want to use
1. install you prefered browser (it is best to do all the online stuff while the defender is still active
2. if you want, disable the windows defender it is easyest to just use the GUI and disabel everything. (alternatively use a [thirdparty windows defender remoover](https://github.com/ionuttbara/windows-defender-remover)
3. runn a (windows debloat tool](https://github.com/LeDragoX/Win-Debloat-Tools)
4. disabe ideling
5. insterting guest additions
    1. while the vm is running: in virtualbox: go to defives -> insert guest Additions CD image
    2.  in the explorer: got to: thie PC -> CD
    3.  choose the to your system corresponding installation file
7. download all your favourite programms. (for inspiration have a look at the [windows programms list](https://github.com/Flottegurke/dotfiles/blob/main/ProgramsReadme.md#windows-programms)
8. reboot for all the changes to take affect
