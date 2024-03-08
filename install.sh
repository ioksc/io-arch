#!/bin/bash

configure_pacman() {
    sed -i -e "/^#Color/c\\Color" \
        -e "/^#VerbosePkgLists/c\\VerbosePkgLists" \
        -e "/^#ParallelDownloads/c\\ParallelDownloads = 12\\nILoveCandy" /etc/pacman.conf
}

fn_header() {
    clear
    gum style --border normal --margin "1" --padding "1 2" --border-foreground 412 "ARCH - $(gum style --foreground 412 'INSTALL')  by ioksc."
}

main() {
    fn_header

    lsblk
    pBOOT=$(gum input --placeholder "Escriba la Particion BOOT(ej.: sda1)")
    pROOT=$(gum input --placeholder "Escriba la Particion ROOT(ej.: sda2)")
    # pHOME=$(gum input --placeholder "Nombre  de la Particion HOME(ej.: sda3)")

    # ------------------------------------------------------
    # Formateamos las particiones
    # ------------------------------------------------------
    echo "Seleccionar formato de la particion:"
    CHOICE=$(gum choose --item.foreground 250 "ext4" "btrfs")

    fn_header
    echo "Seleccionar particiones a$(gum style --foreground "#04B575" " formatear"):"
    PARTITIONS=$(gum choose --cursor-prefix "[ ] " --selected-prefix "[✓] " --no-limit "$pBOOT" "$pROOT")

    grep -q "$pBOOT" <<<"$PARTITIONS" && gum spin -s line --title "Formateando Boot..." -- mkfs.fat -F 32 /dev/$pBOOT
    [[ "$CHOICE" == "ext4" ]] && grep -q "$pROOT" <<<"$PARTITIONS" && gum spin -s line --title "Formateando Root..." -- mkfs.EXT4 /dev/$pROOT
    [[ "$CHOICE" == "btrfs" ]] && grep -q "$pROOT" <<<"$PARTITIONS" && gum spin -s line --title "Formateando Root..." -- mkfs.btrfs -f /dev/$pROOT
    # mkfs.btrfs -f /dev/$pHOME
    echo $pBOOT

    echo $pROOT

    if [[ "$CHOICE" == "ext4" ]]; then 
        mount /dev/$pROOT /mnt/
        mkdir -p /mnt/boot/efi
        mount /dev/$pBOOT /mnt/boot/efi
    else 
        mount /dev/"$pROOT" /mnt
        btrfs su cr /mnt/@
        btrfs su cr /mnt/@cache
        btrfs su cr /mnt/@home
        btrfs su cr /mnt/@snapshots
        btrfs su cr /mnt/@log
        umount /mnt
        mount -o compress=zstd:1,noatime,subvol=@ /dev/"$pROOT" /mnt
        mkdir -p /mnt/{boot/efi,home,.snapshots,var/{cache,log}}
        mount -o compress=zstd:1,noatime,subvol=@cache /dev/"$pROOT" /mnt/var/cache
        mount -o compress=zstd:1,noatime,subvol=@home /dev/"$pROOT" /mnt/home
        mount -o compress=zstd:1,noatime,subvol=@log /dev/"$pROOT" /mnt/var/log
        mount -o compress=zstd:1,noatime,subvol=@snapshots /dev/"$pROOT" /mnt/.snapshots
        mount /dev/"$pBOOT" /mnt/boot/efi
    fi

    configure_pacman
    # gum para el script
    # Para intel: intel-ucode
    pacstrap /mnt base base-devel linux linux-firmware linux-headers vim openssh git gum intel-ucode
    # Para amd: amd-ucode
    # pacstrap /mnt base base-devel linux linux-firmware linux-headers vim openssh git gum amd-ucode 

    # ------------------------------------------------------
    # Generamos el fstab
    # ------------------------------------------------------
    genfstab -U /mnt >> /mnt/etc/fstab
    # cat /mnt/etc/fstab

    mkdir /mnt/custom-arch

    cp post-install.sh /mnt/custom-arch/
    cp app.list /mnt/custom-arch/

    arch-chroot /mnt ./custom-arch/post-install.sh

}

main "$@"
