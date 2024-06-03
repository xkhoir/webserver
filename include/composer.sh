# fungsi untuk menampilkan submenu Composer
show_composer_submenu() {
    echo "1. Install"
    echo "2. Uninstall"
    echo "3. Kembali ke menu utama"
}

# fungsi untuk proses Composer
manage_composer() {
    clear
    action=$1
  if [ "$action" == "install" ]; then
    #install composer
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    php -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
    php composer-setup.php
    php -r "unlink('composer-setup.php');"
    
    #Set Composer to Globally
    echo -e "\nSet Composer to Globally"
    mv composer.phar /usr/bin/composer
    echo -e "\nInstall composer sukses\n"
    sleep 2
  elif [ "$action" == "uninstall" ]; then
    #uninstall composer
    echo -e "\n\nUninstall Composer\n"
    sleep 1
    rm -rf /usr/bin/composer
    echo -e "\nUninstall composer sukses\n"
    sleep 1
  else
    echo "Perintah tidak valid."
  fi
}
