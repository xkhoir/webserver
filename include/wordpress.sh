# fungsi untuk menampilkan submenu Wordpress
show_wordpress_submenu() {
    echo "1. Install"
    echo "2. Uninstall"
    echo "3. Kembali ke menu utama"
}

# fungsi untuk proses Wordpress
manage_wordpress() {
    clear
    action=$1
  if [ "$action" == "uninstall" ]; then
    #Terima input domain
    read -p "Masukkan nama domain wordpress kamu :" DOMAIN
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
    echo -e "\nApps Wordpress pada $DIRECTORY telah dihapus"
    sleep 3

  elif [ "$action" == "install" ]; then
    #Terima input domain
    read -p "Masukkan nama domain wordpress kamu :" DOMAIN
    clear
    #cek paket zip
    check_package "zip" "install"
    #Deklarasi direktori docroot web
    DIRECTORY="/var/www/$DOMAIN/public_html"
    #Deklarasi direktori backup
    BAC="/var/www/$DOMAIN/backup"
    #Membuat folder backup
    mkdir $BAC
    #Memindah kan semua isi di folder dockroot web ke folder backup
    mv $DIRECTORY/* $BAC
    clear
    #Download wordpress 
    wget https://id.wordpress.org/latest-id_ID.zip
    clear
    #Decompres wordpress
    unzip latest-id_ID.zip
    clear
    #copy semua file yang ada di folder wordpress ke docroot web
    cp -r wordpress/* $DIRECTORY
    #hapus folder installer wordpress
    rm -rf wordpress latest-id_ID.zip
    echo -e "\nApp Wordpress telah terinstall di $DIRECTORY"
    echo -e "\nSilahkan akses $DOMAIN"
    sleep 5
  else
    echo "Usage: manage_wordpress [install|uninstall]"
  fi
}