#!/bin/bash

cek_root () {
    # Memeriksa apakah pengguna saat ini login sebagai root
    if [ $(whoami) != "root" ]; then
	clear
        echo -e "\nAnda harus login sebagai root untuk menjalankan perintah ini.\n"
        sleep 2
	return 1
    fi
    return 0
}

# Perintah selanjutnya jika login sebagai root
clear
echo -e "\n Anda dideteksi login sebagai root."
echo -e " Script akan dijalankan.\n"
sleep 2