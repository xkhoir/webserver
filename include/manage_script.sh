#!/bin/bash

source server.sh

cek_new () {
    # Check if there are updates available
    if [[ $(apt list --upgradable 2>/dev/null | wc -l) -gt 1 ]]; then
        echo -e "\nUpdates are available. Running apt update and upgrade."
        manage_server update
        echo -e "\nUpdates Success !!."
    fi
}

# Fungsi untuk memeriksa koneksi internet
# Jika koneksi tersedia, maka fungsi akan mengembalikan nilai 0
# Jika koneksi tidak tersedia, maka fungsi akan mencetak pesan kesalahan dan keluar dengan kode status 1
cek_con() {
    # Mengirim satu paket ke google.com dengan waktu tunggu satu detik
    if ping -q -c 1 -W 1 google.com >/dev/null; then
        # Jika menerima balasan dari google.com, koneksi internet tersedia
        return 0
    else
        # Jika tidak menerima balasan dari google.com, koneksi internet tidak tersedia
        echo "No internet connection"
        exit 1
    fi
}


cek_root () {
	# Mengecek apakah pengguna saat ini adalah root atau bukan
	if [[ $(whoami) != "root" ]]; then
 	  echo -e "\nError: Anda harus menjalankan skrip ini sebagai root" 
	  exit 1
	fi
}

cek_distro () {
    # Mengecek apakah sistem operasi yang sedang berjalan merupakan basis Debian
    if ! cat /etc/*-release | grep -q "ID_LIKE=debian"; then
        echo -e "\nSistem operasi ini bukan basis Debian."
        echo -e "\nScript ini hanya bekerja pada linux basis Debian ."
        exit 1
    fi
}


