<div align="center">
<img src="https://archlinux.org/static/logos/archlinux-logo-light-90dpi.d36c53534a2b.png" height="50px"/> 
<h3>
 [Scripts + Guia] de instalación para Arch-Linux
</h3>
<p>Scripts creados para la instalación automatizada de Arch + Recursos adicionales.</p>
</div>



<p></p> 
<div align="center">

![GitHub stars](https://img.shields.io/github/stars/ioksc/io-arch)
![GitHub issues](https://img.shields.io/github/issues/ioksc/io-arch)
![GitHub forks](https://img.shields.io/github/forks/ioksc/io-arch)
![GitHub PRs](https://img.shields.io/github/issues-pr/ioksc/io-arch)

</div>

> [!NOTE]
> El script de instalacion esta basado  en la guia oficial [**wiki.archlinux.org**](https://wiki.archlinux.org/title/Installation_guide)).

## Descarga de ISO y grabado en USB: 

Descargar desde: https://archlinux.org/download/
- Boot - Linux en USB:
```bash
# Ruta del ISO: /home/ioksc/download/archlinux.iso
# Dispositivo USB: sdc --> /dev/sdc
sudo dd bs=4M if=/home/ioksc/download/archlinux.iso of=/dev/sdc status=progress && sync
```
- Boot- Windows: https://www.ventoy.net/

## Pasos Previos:

## Comprobar el modo de arranque para UEFI
```shell 
ls /sys/firmware/efi/efivars
# Listar 
localectl list-keymaps
# ejemplo de teclado en español es
loadkeys es

timedatectl set-ntp true
``` 
## Comprobar red y conexión a Wifi

```shell  
iwlist wlan0 scan
# wifi WLAN
iwctl --passphrase 'pass' station wlan0 connect 'SSID-name'
# o: iwctl --> station wlan0 scan --> station wlan0 connect 'SSID-name'
```
## Esquema de Particiónes
```shell
cgdisk /dev/sda
#   Type     Value (Hexcode)             Size       
# -----------------------------------------------
# 1 Boot 'EFI System (EF00)'        --> +550M   
# 2 Swap 'Linux Swap (8200)'        --> +2G     
# 3 Root 'Linux-x86-64 / (8304)'    --> +20G    
# 4 Home 'Linux Home (8302)'        --> +100G  
```




## 🚀 Instalación de Arch-Linux

1. Clonar este repositorio.

```bash
git clone https://github.com/ioksc/io-arch.git
```

2. Cambiar de Directorio io-arch


```bash
cd io-arch/scripts
```

- dar permisos de ejecucion al archivo y ejecutar el script:
- EXT4
```bash
chmod +x 1-archinstall-ext4.sh
```
- BTRFS
```bash
chmod +x 1-archinstall-btrs.sh
```
3. Ejecutar el Script  🚀:

```bash
./1-archinstall-ext4.sh
# o
# ./1-archinstall-btrs.sh
```



### 🤝 Contributing

<a href="https://github.com/ioksc/io-arch/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=ioksc/io-arch" />
</a>


## 🛠️ Enlaces Adicionales:

- [**Wiki Arch**](https://wiki.archlinux.org/title/Installation_guide) - Guía Oficial de Instalación.
- [**Modern Unix App**](https://github.com/ibraheemdev/modern-unix) - Alternativas modernas a comandos comunes.


## 🔑 License

[MIT](#) - Created by [**ioksc**](https://github.com/ioksc).

