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
   echo "CPU Model        : $cores x$processor";
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
    echo "3. Caddy"
    echo "4. PHP"
    echo "5. Mariadb"
    echo "6. PhpMyAdmin"
    echo "7. Composer"
    echo "8. Wordpress"
    echo "9. Cockpit"
    echo "10. Speedtest"
    echo "11. Manage Server"
    echo "12. Keluar"
}