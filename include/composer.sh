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
    php -r "if (hash_file('sha384', 'composer-setup.php') === 'e21205b207c3ff031906575712edab6f13eb0b361f2085f1f1237b7126d785e826a450292b6cfd1d64d92e6563bbde02') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
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
