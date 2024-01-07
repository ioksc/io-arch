#!/bin/bash

clear
echo "    _             _       ___           _        _ _ "
echo "   / \   _ __ ___| |__   |_ _|_ __  ___| |_ __ _| | |"
echo "  / _ \ | '__/ __| '_ \   | || '_ \/ __| __/ _' | | |"
echo " / ___ \| | | (__| | | |  | || | | \__ \ || (_| | | |"
echo "/_/   \_\_|  \___|_| |_| |___|_| |_|___/\__\__,_|_|_|"
echo ""
# ------------------------------------------------------
# Extracted from --> Stephan-Raabe: https://gitlab.com/stephan-raabe/archinstall.git
# ------------------------------------------------------

# ------------------------------------------------------
# Escribimos las particiones creadas
# ------------------------------------------------------
lsblk
read -p "Escriba el Nombre de la Particion BOOT EFI (ej. sda1): " sda1
read -p "Escriba el Nombre de la Particion ROOT     (ej. sda2): " sda2
# read -p "Escriba el Nombre de la Particion Swap     (ej. sda3): " sda3
# read -p "Escriba el Nombre de la Particion Home     (ej. sda4): " sda4

# ------------------------------------------------------
# Sincronizamos
# ------------------------------------------------------
timedatectl set-ntp true
# ------------------------------------------------------
# Formateamos las particiones
# ------------------------------------------------------

mkfs.fat -F 32 /dev/$sda1;
mkfs.btrfs -f /dev/$sda2
# mkfs.btrfs -f /dev/$sda3

# ------------------------------------------------------
# Mount points for btrfs
# ------------------------------------------------------
mount /dev/$sda2 /mnt
btrfs su cr /mnt/@
btrfs su cr /mnt/@cache
btrfs su cr /mnt/@home
btrfs su cr /mnt/@snapshots
btrfs su cr /mnt/@log
umount /mnt

mount -o compress=zstd:1,noatime,subvol=@ /dev/$sda2 /mnt
mkdir -p /mnt/{boot/efi,home,.snapshots,var/{cache,log}}
mount -o compress=zstd:1,noatime,subvol=@cache /dev/$sda2 /mnt/var/cache
mount -o compress=zstd:1,noatime,subvol=@home /dev/$sda2 /mnt/home
mount -o compress=zstd:1,noatime,subvol=@log /dev/$sda2 /mnt/var/log
mount -o compress=zstd:1,noatime,subvol=@snapshots /dev/$sda2 /mnt/.snapshots
mount /dev/$sda1 /mnt/boot/efi
# mkdir /mnt/vm
# mount /dev/$sda3 /mnt/vm


pacstrap /mnt base base-devel linux linux-firmware vim openssh git intel-ucode

# ------------------------------------------------------
# Generamos el fstab
# ------------------------------------------------------
genfstab -U /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab


mkdir /mnt/custom-arch

cp 2-configurations.sh /mnt/custom-arch/
cp applist.txt /mnt/custom-arch/

arch-chroot /mnt ./custom-arch/2-configurations.sh