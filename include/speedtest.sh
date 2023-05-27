# fungsi untuk menampilkan submenu Composer
show_speedtest_submenu() {
    echo "1. Install"
    echo "2. Uninstall"
    echo "3. Kembali ke menu utama"
}

# fungsi untuk proses Composer
manage_speedtest() {
    clear
    action=$1
    if [ "$action" == "uninstall" ]; then
    #Terima input domain
    read -p "Masukkan nama domain speedtest kamu :" DOMAIN
    clear
    #Deklarasi direktori docroot web
    DIRECTORY="/var/www/$DOMAIN/public_html"
    #Deklarasi direktori backup
    BAC="/var/www/$DOMAIN/backup"
    #Menghapus semua file yang ada di dalam docroot web
    rm -rf $DIRECTORY/*
    #Memindah kan semua isi di folder backup ke docroot web
    mv $BAC/* $DIRECTORY
    #Menghapus folder backup
    rm -rf $BAC
    echo -e "\nApp Speedtest pada $DIRECTORY telah dihapus"
    sleep 3

  elif [ "$action" == "install" ]; then
    #Terima input domain
    read -p "Masukkan nama domain speedtest kamu :" DOMAIN
    clear
    #Terima input provider
    read -p "Masukkan nama provider vps kamu : " PROVIDER
    clear
    #Deklarasi string isi index.html
    TITLE="$PROVIDER Speedtest Server"
    #cek paket zip
    check_package "zip" "$action"
    #Deklarasi direktori docroot web
    DIRECTORY="/var/www/$DOMAIN/public_html"
    #Deklarasi direktori backup
    BAC="/var/www/$DOMAIN/backup"
    #Membuat folder backup
    mkdir $BAC
    #Memindah kan semua isi di folder dockroot web ke folder backup
    mv $DIRECTORY/* $BAC
    clear
    #Download librespeed speedtest app
    wget https://github.com/librespeed/speedtest/archive/refs/heads/master.zip
    clear
    #Decompres master.zip
    unzip master.zip
    clear
    #copy semua file yang ada di folder speedtest-master ke docroot web
    cp -r speedtest-master/* $DIRECTORY
    #hapus folder installer speedtest app
    rm -rf master.zip speedtest-master
    #rename example-singleServer-full.html ke index.html
    mv $DIRECTORY/example-singleServer-full.html $DIRECTORY/index.html
    #mengubah isi index.html
    sed -i "276s/LibreSpeed Example/$TITLE/" $DIRECTORY/index.html
    sed -i "279s/LibreSpeed Example/$TITLE/" $DIRECTORY/index.html
    sed -e '320d' $DIRECTORY/index.html

    echo -e "\nApp Speedtest telah terinstall di $DIRECTORY"
    echo -e "\nSilahkan akses $DOMAIN"
    sleep 5
  else
    echo "Usage: manage_wordpress [install|uninstall]"
  fi
}