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
    read -p "Masukkan nama domain wordpress kamu :" DOMAIN
    clear
    DIRECTORY="/var/www/$DOMAIN/public_html"
    rm -rf $DIRECTORY/*
    mv /var/www/$DOMAIN/* $DIRECTORY/
    echo -e "\nWordpress pada $DIRECTORY telah dihapus"
    sleep 5

  elif [ "$action" == "install" ]; then
    read -p "Masukkan nama domain kamu :" DOMAIN
    clear
    DIRECTORY="/var/www/$DOMAIN/public_html"
  
    mv $DIRECTORY/* /var/www/$DOMAIN
    check_package "zip" "install"
    clear
    wget https://id.wordpress.org/latest-id_ID.zip
    clear
    unzip latest-id_ID.zip
    clear
    cp -r wordpress/* $DIRECTORY
    rm -rf wordpress
    echo -e "\nWordpress telah terinstall di $DIRECTORY"
    echo -e "\nSilahkan akses $DOMAIN"
    sleep 5
  else
    echo "Usage: manage_wordpress [install|uninstall]"
  fi
}