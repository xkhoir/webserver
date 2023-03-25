# fungsi untuk menampilkan header
show_header() {
   clear
   echo "       Lamp Stack Server Auto Installer by       ";
   figlet xkhoirtech
   echo "=================================================";
   echo -n "Waktu system    : "; date
   echo -n "Status pengguna : "; whoami
   echo -n "Banyak user     : "; who | wc -l
   echo "=================================================";
   echo "-------- Silahkan pilih salah satu opsi: --------";
}

# fungsi untuk menampilkan menu utama
show_menu() {
    echo "1. Apache"
    echo "2. PHP"
    echo "3. Mariadb"
    echo "4. PhpMyAdmin";
    echo "5. Composer";
    echo "6. Reboot Server";
    echo "7. Keluar"
}