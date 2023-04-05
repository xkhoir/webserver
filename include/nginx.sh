#!/bin/bash

# fungsi untuk menampilkan submenu Apache
show_nginx_submenu() {
    echo "1. Install"
    echo "2. Uninstall"
    echo "3. Setup New Domain Directory"
    echo "4. Setup SSL Let's Encrypt"
    echo "5. Renew SSL Let's Encrypt"
    echo "6. a2enmod rewrite"
    echo "7. Restart/reload Nginx Service"
    echo "8. Kembali ke menu utama"
}

# fungsi untuk proses Apache
manage_nginx() {
    clear
    package="nginx"
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
    #Proses restart/reload nginx service
    echo -e "Restart/reload service nginx\n"
    sleep 2
    sudo systemctl reload nginx
    sudo systemctl restart nginx
  else
    echo "Perintah tidak valid."
  fi
}