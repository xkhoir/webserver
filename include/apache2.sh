
# fungsi untuk menampilkan submenu Apache
show_apache_submenu() {
    echo "1. Install"
    echo "2. Uninstall"
    echo "3. Tambah Domain ke Vhost"
    echo "4. Tambah Domain dengan Proxy ke Vhost"
    echo "5. Hapus Domain dari Vhost"
    echo "6. Setup SSL Let's Encrypt"
    echo "7. Renew SSL Let's Encrypt"
    echo "8. a2enmod rewrite"
    echo "9. Restart/reload Apache Service"
    echo "10. Kembali ke menu utama"
}

# fungsi untuk proses Apache
manage_apache() {
    clear
    package="apache2"
    action=$1
  if [ "$action" == "uninstall" ]; then
    #parsing data ke fungsi check_package
    check_package "$package" "$action"
    # rm -rf /var/lib/apache*
    # rm -rf /var/log/apache*
    # rm -rf /var/www/*
    # rm -rf /etc/apache*
    # rm -rf /etc/letsencry*
  elif [ "$action" == "install" ]; then
    #parsing data ke fungsi check_package
    check_package "$package" "$action"
  elif [ "$action" == "adddomain" ]; then
      domain_setup "$action"
  elif [ "$action" == "addproxydomain" ]; then
      domain_setup "$action"
  elif [ "$action" == "deletedomain" ]; then
      domain_setup "$action"
  elif [ "$action" == "ssl" ]; then
    #call function ssl setup
    ssl_setup "apache"
  elif [ "$action" == "sslrenew" ]; then
    read -p "Ketikkan Nama Domain Anda (contoh: example.com): " dns
    #call function ssl setup
    ssl_setup "apache" "$dns"
  elif [ "$action" == "a2enmod" ]; then
    #call function ssl renew
    a2enmod rewrite
  elif [ "$action" == "restart" ]; then
    #Proses restart/reload apache2 service
    echo -e "Restart/reload service $package\n"
    sleep 2
    # sudo systemctl reload apache2
    sudo systemctl reload $package
    sudo systemctl restart $package
  else
    echo "Perintah tidak valid."
  fi
}