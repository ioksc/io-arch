#!/bin/bash

clear
echo "    _             _       ___           _        _ _ "
echo "   / \   _ __ ___| |__   |_ _|_ __  ___| |_ __ _| | |"
echo "  / _ \ | '__/ __| '_ \   | || '_ \/ __| __/ _' | | |"
echo " / ___ \| | | (__| | | |  | || | | \__ \ || (_| | | |"
echo "/_/   \_\_|  \___|_| |_| |___|_| |_|___/\__\__,_|_|_|"
echo ""
# ------------------------------------------------------
# Basada en archinstall de Stephan-Raabe: https://gitlab.com/stephan-raabe/archinstall.git
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
mkfs.fat -F32 /dev/$sda1;
mkfs.ext4 /dev/$sda2
# mkfs.ext4 /dev/$sda4

# ------------------------------------------------------
# Montamos las particiones
# ------------------------------------------------------
mount /dev/sda2 /mnt/

mkdir -p /mnt/boot/efi/

mount /dev/sda1 /mnt/boot/efi/

# mkdir -p /mnt/home/
# mount /dev/sda3 /mnt/home/


# ------------------------------------------------------
# Instalamos los Paquetes base
# ------------------------------------------------------

pacstrap -K /mnt base base-devel linux linux-firmware vim openssh git intel-ucode

# ------------------------------------------------------
# Generamos el fstab
# ------------------------------------------------------
genfstab -U /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab


mkdir /mnt/custom-arch

cp 2-configurations.sh /mnt/custom-arch
cp applist.txt /mnt/custom-arch

arch-chroot /mnt ./custom-arch/2-configurations.sh

