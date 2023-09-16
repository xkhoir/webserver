# Fungsi untuk memeriksa os baru diinstall dalama kurun waktu 1 jam, maka perintah update jalan
cek_new () {
    # Dapatkan waktu instalasi Linux
    waktu_instalasi=$(stat -c %Y /var/log/installer)

    # Dapatkan waktu saat ini
    waktu_sekarang=$(date +%s)

    # Hitung selisih waktu antara waktu instalasi dan waktu saat ini dalam detik
    selisih_waktu=$((waktu_sekarang - waktu_instalasi))

    # Konversi 1 jam ke dalam detik
    satu_jam=3600

    # Periksa apakah selisih waktu kurang dari 1 jam (3600 detik)
    if [ "$selisih_waktu" -lt "$satu_jam" ]; then
        # Lakukan update sistem
        apt update
        apt upgrade -y
    fi
    # Lanjutkan dengan kode selanjutnya
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
        clear
        # Jika tidak menerima balasan dari google.com, koneksi internet tidak tersedia
        echo "No internet connection"
        sleep 2
        clear
        exit 1
    fi
}


cek_root () {
	# Mengecek apakah pengguna saat ini adalah root atau bukan
	if [[ $(whoami) != "root" ]]; then
        clear
 	    echo -e "\nError: Anda harus menjalankan skrip ini sebagai root"
        sleep 2
        clear
	    exit 1
	fi
}

cek_distro () {
    # Mengecek apakah sistem operasi yang sedang berjalan merupakan basis Debian
    if ! cat /etc/*-release | grep -q "ID_LIKE=debian"; then
        clear
        echo -e "\nSistem operasi ini bukan basis Debian."
        echo -e "\nScript ini hanya bekerja pada linux debian dan turunannya ."
        sleep 2
        clear
        exit 1
    fi
}


