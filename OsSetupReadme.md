## OS - Setup
This is a short description on how to setup arch-linux to wort with my dotfiles
> [!CAUTION]
> This installation description is a quickinstall guide, for users that are already a bit fammiliar with arch.
> If you are not experienced jet, I strongly recommend lerarning about arch linux, befor installing it relying on guides, since arch is not optimised to be beginner firendly, but instead to best serve the people using it.
> 
> If you do not want to put in the time to learn about arch (which is totaly understandable), I reccoment using more beginner firendly liunx distros like [Mint](https://linuxmint.com/) or [Fedora](https://fedoraproject.org/en/).

### 1. Partitioning
If dual boot is desired, firstly allocate at minimum 40GB of free space using the already installed OS (for windows use `diskmgnt` or if this does not work: `MiniTool Patition Wizard`).
> [!TIP]
> if the resicing fails, execute `powercfg /h off` and `chkdsk C: /f /r` in the terminal as an administrator


### 2. Creating a bootable Pen Drive
Firstly download the [arch-linux iso file](https://archlinux.org/download/).
Then chreate a bootable Pen drive using for example [Rufus](https://rufus.ie/en/) in windows.
- for dual booting with windows, choose GPT as the partition sceme, to prevent issues with UEFI


### 3. Backup
Now is a good time to chreate a bacup of the already installed OS, if dual booting is desired. On windows this can be done by [creating a System restore point](https://support.microsoft.com/en-us/windows/system-protection-e9126e6e-fa64-4f5f-874d-9db90e57645a)


### 4. Disabeling disk encryption
Disc recryption will likely interfer with the installation process, so it should get turned of.

On windows this feature is called Bit locker and can be turned of [like this](https://linuxbsdos.com/2024/10/15/how-to-disable-bitlocker-encryption-in-windows-11/).


### 5. BIOS Settings
To boot into linux, it is likely that some BIOS settings need to be changed.
1. Boot into BIOS (for HP computers rappidly press the ESC key while the computer is turning on)
2. Disable `Secure Boot`. This is verry important, as the computer won't boot into the Pen drive otherwise.
3. Change the boot order. The `USB flash drive` entry needs to be higher on the boot order then the OS `Boot Manager` option. (Instead of changing the boot order, you can also use the Boot list menu instead of booting into BIOS after disabeling secure boot)


### 6. Basic setup
1. Once booted into linux, make sure, the PC is connected to the internet (for example using: `ping google.de`)
> [!TIP]
> type `setfont ter-132n` to increase the font sice
> 
> If you want to use the built in WIFI to connect to the ethernet, [use `iwctl`](https://joshtronic.com/2021/11/21/connecting-to-wifi-with-iwd/) to do so.

2. Synchronize package databases by executing `pacman -Sy`
3. Install archlinux-keyring: `pacman -S archlinux-keyring`
4. Install/update archinstall scrips by executing `pacman -S archinstall`
If no dual boot is desired, skip to [Using the archinstall script](https://github.com/Flottegurke/dotfiles/edit/main/README.md#7-using-the-archinstall-script)
5. indentify the identifyer of the voulume you want to use by typing `lsblk` and searching for an entry with as many free space as you allocated earlyer. (An example for th identifyer is `nvme0n1`.)
6. chreate partitions
   1. type `cfdisk /dev/<identifyer>`
   2. make shure you see a free space entry with roughly the sice of free space you allocated
   3. Select the Free space entry and chreate a new partition by pressing `enter`.
      Then set the partition sice to `1G`.
   5. Set the type of the new partition to `EFI System` by selecting it and choosing `Type`
   6. Select the `Free space` entry again and chreate a new partition by pressing `enter`.
      To use the remaining free space, press `Enter` without changing the sice.
   7. make shure, that the new partition has the type `Linux filesystem`, and if it has not, change it.
   8. Memorise or write down the identifyer of the 2 new partitions. They should look somthing like `/dev/nvme0np5` where `nvme0np5` is the identifyer.
     
       These 2 names will be refered to as `<UEFIPartitonIdentifyer>` for the 1G partition, and `<filesystemPartitionIdentifyer>` for the other one.
   9. Write the changes by selecting `Write` and confirming. Then quit by selecting `Quit`.
   10. Make shure the new partitions show up, by once again typing `lsblk`.
   11. Format the new partitions by executing `mkfs.fat -F32 /dev/<UEFIPartitonIdentifyer>` and `mkfs.ext4 /dev/<filesystemPartitionIdentifyer>`.
   12. Mount the filesystem partition by typing `mount /dev/<filesystemPartitionIdentifyer> /mnt`
   13. chreate a directory in it: `mkdir /mnt/boot`
   14. mount the UEFI partition to this directory: `mount /dev/<UEFIPartitonIdentifyer> /mnt/boot`
   15. verrify correct setup by typing `lsblk`once again and looking for a `/mnt/boot/`entry behind the UEFI partition, and a `/mnt` enztry behind the filesystem partition.


### 7. using the archinstall script
1. Type `archinstall` to start the process.
2. Set `Archinstall language` to you prefered language.
4.  Set `Keyboard layout` and `Locale language` inside the `Locales`option.
> [!TIP]
> after you saved you keyboard layout, you can press `/` at anny point during the installation to search for entrys.
6.  Inside the `Mirrors` option select the neares few countrys aroudn you, for faster package downloads.
7.  Inside `Disk Configuration` -> `Partitioning`:

    If dual boot is desired and you followed steps 5 and 6 of [6. Basic setup](https://github.com/Flottegurke/dotfiles/edit/main/README.md#6-basic-setup), choose `Pre-mounted configuration`, press `Enter` and type `/mnt` inside the `Root mount directory` promt.

    Otherwise choose `Use a best-efford default partition layout`

8.  If you want disk encryption, enable it insie the `Disc encryption` option.
9. If not already enabled, enable `Swap` inside the `Swap` option.
10. Inside `Bootloader` choose `systemd` or `GRUB` (`GRUB` is recoomended for dual boot)
11. Set `Hostname`as `archlinux`
12. Choose a `Root password` you like.
13. Inside the `User accoutn`option:
    1. Choose `Add a user`
    2. Choose a username
    3. Set and confirm a password
    4. choose whether the user should be a `superuser` (this is reccomended)
    5. Choose `confirm and exit`.
14. Inside the `Profile` -> `Type` option
    1. Choose `Desktop`
    2. choose a desktop environment (`GNOME` is reccomended, for an easy fallback option if `Hyprland`breaks)
    3. Select `Graphic driver` and choose `Intel (open-source)` for intel GPUs, `AMD / ATI (open-source)` for AMD GPUs and `Nvidia (proprietary)` dor Invidia GPUs.
    4. Select the `greeter` you prefer (`gdm` is prefered for `GNOME` (it later is explained how to change the Display Manager(Login Manager))
15. The recomended option for the `Audio` category is `pipewire`.
16. Under `Kernels` install additional Kernels if desired. (Ownly choosing `linux`is reccomended).
17.  Insde the `Network configuration` choose `Use NetworkManager (nessesary to configure internet graphically in GNOME and KDE Plasma)`
18.  Choose additional programms, which should get installd inside the `Additional packages` option (none is recomended, because i had installations fail in the past due to typos in additional packages)
19.  Inside `Optional repositories` choose `multilib` which is required to runn 32 Bit applications (like steam).
20.  Enable `Automatic time sync (NTP)` if it is not enabled.
21.  Check all configrations again to make shure everything is set up correctly.
22.  Select `Instal`and then `Yes`.

### 8. Post installation steps
After the installation is finished, you woill be asked, if you want to perform post installation steps.

As of 2025, GRUB is not installed correctly while dualbooting with windows. Therefore, while dualbooting, it must be installed mannualy, so you should select: `yes`.

To install GRUB mannualy:
1. Once again refrest all packages and do a full system update and upgrade: `pacman -Syu`
2. to install grub, type `pacman -S grub efibootmgr dosfstools mtools`
3. Install grub into the boot partition: `grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB`
4. Then generate a configuration file by typing: `grub-mkconfig -o /boot/grub/grub.cfg`

The last step is to install flatpac, to prevent bugs: `pacman -S flatpak`.


### 9. Potential bug fixes
Now restart the computer by exeting chroot: `exit` and then typing `reboot now`. While the PC reboots, eject the pen drive.

If you are dual booting, the PC might not use grub. in this case change the order of the bootmanegers in the BIOS.
After the restart, you will see GRUB and after 5 seconds, it will boot into linux.

If, now a kernal pannic (Blue screen) appears, restart the computer and select `Advanced options for Arch Linux` and then `Save/Faalback mode`.
After then logging in into your account, and restarting the PC, averything should now work normaly.
