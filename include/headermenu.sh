# Mengambil informasi tentang prosesor pada sistem
processor=$(cat /proc/cpuinfo | grep "model name" | head -n 1 | cut -d ":" -f 2)
cores=$( awk -F: '/processor/ {core++} END {print core}' /proc/cpuinfo )
architecture=$(uname -m)

# fungsi untuk menampilkan header
show_header() {
   clear
   echo "       Lamp Stack Server Auto Installer by       ";
   echo "                   xkhoirtech                     ";
   echo "=================================================";
   echo "Nama prosesor    :$cores x $processor";
   echo "Arsitektur       : $architecture";
   echo -n "Waktu system     : "; date
   echo -n "Status pengguna  : "; whoami
   echo "=================================================";
   echo "-------- Silahkan pilih salah satu opsi: --------";
}

# fungsi untuk menampilkan menu utama
show_menu() {
    echo "1. Apache"
    echo "2. Nginx"
    echo "3. PHP"
    echo "4. Mariadb"
    echo "5. PhpMyAdmin"
    echo "6. Composer"
    echo "7. Wordpress"
    echo "8. Cockpit"
    echo "9. Speedtest"
    echo "10. Manage Server"
    echo "11. Keluar"
}