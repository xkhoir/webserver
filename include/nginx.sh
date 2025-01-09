
# fungsi untuk menampilkan submenu Apache
show_nginx_submenu() {
    echo "1. Install"
    echo "2. Uninstall"
    echo "3. Tambah Domain ke Server Blok"
    echo "4. Tambah Domain dengan Proxy ke Server blok"
    echo "5. Hapus Domain dari Server blok"
    echo "6. Setup SSL Let's Encrypt"
    echo "7. Renew SSL Let's Encrypt"
    echo "8. Restart/reload Nginx Service"
    echo "9. Kembali ke menu utama"
}

# fungsi untuk proses Apache
manage_nginx() {
    clear
    package="nginx"
    action=$1
  if [ "$action" == "uninstall" ]; then
    #parsing data ke fungsi check_package
    check_package "$package" "$action"
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
    read -p "Ketikkan Nama Domain Anda (contoh: example.com): " dns
    #call function ssl setup
    ssl_setup "nginx" "$dns"
  elif [ "$action" == "sslrenew" ]; then
    #code
    ssl_renew
  elif [ "$action" == "restart" ]; then
    #Proses restart/reload nginx service
    echo -e "Restart/reload service $package\n"
    sleep 2
    sudo systemctl reload $package
    sudo systemctl restart $package
  else
    echo "Perintah tidak valid."
  fi
}