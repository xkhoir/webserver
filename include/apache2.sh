# Memanggil fungsi bash dari file yang berbeda
source check_package.sh
source domainsetup.sh

# fungsi untuk menampilkan submenu Apache
show_apache_submenu() {
    echo "1. Install"
    echo "2. Uninstall"
    echo "3. Setup New Domain Directory"
    echo "4. Setup SSL Let's Encrypt"
    echo "5. Renew SSL Let's Encrypt"
    echo "6. a2enmod rewrite"
    echo "7. Restart/reload Apache Service"
    echo "8. Kembali ke menu utama"
}

# fungsi untuk proses Apache
manage_apache() {
    clear
    package="apache2"
    action=$1
  if [ "$action" == "uninstall" ]; then
    #parsing data ke fungsi check_package
    check_package "$package" "uninstall"
  elif [ "$action" == "install" ]; then
    #parsing data ke fungsi check_package
    check_package "$package" "install"
  elif [ "$action" == "domainsetup" ]; then
    #code
    domain_setup
  elif [ "$action" == "ssl" ]; then
    #code
    ssl_setup
  elif [ "$action" == "sslrenew" ]; then
    #code
    ssl_renew
  elif [ "$action" == "restart" ]; then
    #Proses restart/reload apache2 service
    echo -e "Restart/reload service apache2\n"
    sleep 2
    sudo systemctl reload apache2
    sudo systemctl restart apache2
  else
    echo "Perintah tidak valid."
  fi
}