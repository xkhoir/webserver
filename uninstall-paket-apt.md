# Uninstall paket APT
Berikut cara melepas apket apt manual.

## Uninstall paket
lihat paket apt yang sedang terpasang

    sudo apt list --installed

ganti **namapaket** dengan namapaket yang akan di uninstall

    sudo apt-get remove --purge namapaket -y
 Lakukan autoremove agar bersih sampai ke akar.

    sudo apt autoremove -y && sudo apt clean
    
