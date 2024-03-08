#!/bin/bash
clear
# ------------------------------------------------------
# <Configurar> Editar antes de ejecutar
KEYBOARDLAYOUT="us" # es, us
TIMEZONE="" # Elija la zona horaria: America/Los_Angeles | Dejar Blanco para automatizar
HOSTNAME="<pc-name>" # Nombre de la Maquina
USERNAME="<user1>" # Nombre de Usuario
ENCODING="en_US.UTF-8" # "es_ES.UTF-8" - Sistema de Codificación
# ------------------------------------------------------

# ------------------------------------------------------
# Establecer la zona horario para sync
# ------------------------------------------------------
configure_pacman() {
    sed -i -e "/^#Color/c\\Color" \
        -e "/^#VerbosePkgLists/c\\VerbosePkgLists" \
        -e "/^#ParallelDownloads/c\\ParallelDownloads = 12\\nILoveCandy" /etc/pacman.conf
}




if [ -z "$ZONEINFO" ]; then
    TIMEZONE=$(curl https://ipapi.co/timezone)
fi
ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
hwclock --systohc

# pacman -Syy
configure_pacman
# ------------------------------------------------------
# Install Packages
# ------------------------------------------------------
pacman --needed --noconfirm -S -< /custom-arch/app.list

# ------------------------------------------------------
# <Configurar> Establecer el Lenguaje utf8 ES
# ------------------------------------------------------
echo "$ENCODING UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG='$ENCODING" >> /etc/locale.conf

# ------------------------------------------------------
# Establcecer la configuracion del Teclado
# ------------------------------------------------------
echo "FONT=ter-v18n" >> /etc/vconsole.conf
echo "KEYMAP=$KEYBOARDLAYOUT" >> /etc/vconsole.conf

# ------------------------------------------------------
# Establecer el hostname y el archivos hosts
# ------------------------------------------------------
echo "$HOSTNAME" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 $HOSTNAME.localdomain $HOSTNAME" >> /etc/hosts

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
echo "Añadiendo el usuario $USERNAME"
useradd -m -G wheel $USERNAME
passwd $USERNAME

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
usermod -aG wheel $USERNAME

echo "Instalacion Completada, para salir"
echo "exit"
echo "umount -a"
echo "Reiniciar"
