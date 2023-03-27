#!/bin/bash

cek_root () {
	# Mengecek apakah pengguna saat ini adalah root atau bukan
	if [[ $(whoami) != "root" ]]; then
	  clear
 	  echo "Error: Anda harus menjalankan skrip ini sebagai root" 
 	  sleep 2
	  clear
	  exit 1
	fi
	
	# Perintah selanjutnya jika login sebagai root
	clear
	echo -e "\n Anda dideteksi login sebagai root."
	echo -e " Script akan dijalankan.\n"
	sleep 2
}

