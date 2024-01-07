#!/bin/bash
clear
# ------------------------------------------------------
# <Configurar> Editar antes de ejecutar
keyboardlayout="us"
zoneinfo="America/Los_Angeles"
hostname="<pc-name>"
username="<user1>"
# ------------------------------------------------------

# ------------------------------------------------------
# Establecer la zona horario para sync
# ------------------------------------------------------
ln -sf /usr/share/zoneinfo/$zoneinfo /etc/localtime
hwclock --systohc

# pacman -Syy

# ------------------------------------------------------
# Install Packages
# ------------------------------------------------------
pacman --noconfirm -S $(cat /custom-arch/applist.txt)

# ------------------------------------------------------
# <Configurar> Establecer el Lenguaje utf8 ES
# ------------------------------------------------------
echo "es_ES.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=es_ES.UTF-8" >> /etc/locale.conf

# ------------------------------------------------------
# Establcecer la configuracion del Teclado
# ------------------------------------------------------
echo "KEYMAP=$keyboardlayout" >> /etc/vconsole.conf

# ------------------------------------------------------
# Establecer el hostname y el archivos hosts
# ------------------------------------------------------
echo "$hostname" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 $hostname.localdomain $hostname" >> /etc/hosts

# ------------------------------------------------------
# Habilitar Servicios
# ------------------------------------------------------
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable sshd
systemctl enable avahi-daemon
systemctl enable acpid

clear

# ------------------------------------------------------
# Establecer Contraseña de Root
# ------------------------------------------------------
echo "Establecer contraseña para ROOT"
passwd root

# ------------------------------------------------------
# Agregar usuario
# ------------------------------------------------------
echo "Añadiendo el usuario $username"
useradd -m -G wheel $username
passwd $username

# ------------------------------------------------------
# Instalación de Grub
# ------------------------------------------------------
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=ARCH --removable
grub-mkconfig -o /boot/grub/grub.cfg


# ------------------------------------------------------
# Agregar el usuario al grupo: wheel
# ------------------------------------------------------
clear
echo "Descomentar %wheel group en el archivo sudoers:"
echo "Antes  : #%wheel ALL=(ALL:ALL) ALL"
echo "Despues: %wheel ALL=(ALL:ALL) ALL"
echo ""
read -p "Open sudoers now?" c
EDITOR=vim sudo -E visudo
usermod -aG wheel $username

echo "Instalacion Completada, para salir"
echo "exit"
echo "umount -a"
echo "Reiniciar"
