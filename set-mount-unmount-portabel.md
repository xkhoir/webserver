# Cara Mount dan Unmount portabel device
Berikut caranya : 
## Cara mount flasdisk
cek dir device sda or sdb 

    sudo fdisk -l

## Create mount point

    mkdir -p /media/flashdrive && mount /dev/sda1 /media/flashdrive

## Unmount

    umount /media/flashdrive
