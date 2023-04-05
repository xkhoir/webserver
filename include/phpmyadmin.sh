# Memanggil fungsi bash dari file yang berbeda
# source check_package.sh

# fungsi untuk menampilkan submenu PhpMyAdmin
show_phpmyadmin_submenu() {
    echo "1. Install"
    echo "2. Uninstall"
    echo "3. Update"
    echo "4. Kembali ke menu utama"
}

# fungsi untuk proses PhpMyAdmin
manage_phpmyadmin() {
    clear
    package="phpmyadmin"
    action=$1
  if [ "$action" == "uninstall" ]; then
    #parsing data ke fungsi check_package
    check_package "$package" "uninstall"
  elif [ "$action" == "install" ]; then
    #parsing data ke fungsi check_package
    check_package "$package" "install"
  elif [ "$action" == "update" ]; then
    #download via https://www.phpmyadmin.net/
    echo -e "\nDownloading latest PhpMyAdmin...\n"
    wget https://files.phpmyadmin.net/phpMyAdmin/latest/phpMyAdmin-latest-all-languages.tar.gz
    tar -xvzf phpMyAdmin-latest-all-languages.tar.gz
    #create backup file phpmhadmin.bak
    echo -e "\nBackup PhpMyAdmin...\n"
    sleep 2
    #remove backup phpmyadmin.bak file
    rm -rf /usr/share/phpmyadmin.bak
    #move new backup fille to /usr/share/phpmyadmin.bak
    mv /usr/share/phpmyadmin/ /usr/share/phpmyadmin.bak
    #copy config.inc.php from backup file to /usr/share/phpmyadmin/
    echo -e "\nCopy config.inc.php from /usr/share/phpmyadmin.bak...\n"
    sleep 2
    cp /usr/share/phpmyadmin.bak/config.inc.php /usr/share/phpmyadmin/config.inc.php
    echo -e "\nCopy lastest phpmyadmin to /usr/share/phpmyadmin/...\n"
    sleep 2
    #copy new phpmyadmin file to /usr/share/phpmyadmin/
    cp -r phpMyAdmin-*/* /usr/share/phpmyadmin/
    #remove new phpmyadmin file after download
    rm -rf phpMyAdmin-*
    echo "phpMyAdmin has been updated to the latest version."
    sleep 2
  else
    echo "Usage: manage_phpmyadmin [install|uninstall|update]"
  fi
}
