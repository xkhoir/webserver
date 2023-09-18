# fungsi untuk menampilkan submenu Cockpit
show_cockpit_submenu() {
    echo "1. Install"
    echo "2. Uninstall"
    echo "3. Kembali ke menu utama"
}

# fungsi untuk proses Cockpit
manage_cockpit() {
    clear
    package="cockpit"
    action=$1
  if [ "$action" == "install" ]; then
    #Add repo
    curl -sSL https://repo.45drives.com/setup -o setup-repo.sh
    sudo bash setup-repo.sh
    #install cockpit
    check_package "apache2" "$action"
    check_package "$package" "$actionl"
    check_package "$package-storaged" "$action"
    check_package "$package-networkmanager" "$action"
    check_package "$package-packagekit" "$action"
    check_package "$package-file-sharing" "$action"
    check_package "$package-navigator" "$action"
    check_package "$package-identities" "$action"
    systemctl enable cockpit

    # # konfigurasi yang akan dimasukkan ke dalam file
    # isi="[keyfile]\nunmanaged-devices=none"
    # # Buat file 10-globally-managed-devices.conf
    # touch /etc/NetworkManager/conf.d/10-globally-managed-devices.conf
    # # jalankan perintah echo untuk menambahkan konfigurasi ke dalam file
    # echo -e "$isi" >> /etc/NetworkManager/conf.d/10-globally-managed-devices.conf
    # nmcli con add type dummy con-name fake ifname fake0 ip4 1.2.3.4/24 gw4 1.2.3.1
    # systemctl restart NetworkManager

    echo -e "\nMemasang cockpit di domain? (y/n)"
    read CEK

    if [ "$CEK" == "y" ]; then
        # call domain_setup
        domain_setup "addproxydomain"
        add_cockpit_conf
        systemctl restart cockpit
        add_cockpit_proxy
    else
        echo -e "\nOK, akses cockpit di localhost anda pada port 9090,"
    fi
  elif [ "$action" == "uninstall" ]; then
    #uninstall cockpit
    check_package "$package" "$action"
    echo "" > /etc/cockpit/cockpit.conf
    # echo "" > /etc/NetworkManager/conf.d/10-globally-managed-devices.conf
    # nmcli con delete con-name fake
    systemctl restart cockpit.service
    systemctl restart NetworkManager
  else
    echo "Perintah tidak valid."
  fi
}

add_cockpit_conf () {
    # konfigurasi yang akan dimasukkan ke dalam file
    config="[WebService]\nOrigins = https://$DOMAIN http://$DOMAIN http://localhost:9090\nProtocolHeader = X-Forwarded-Proto\nAllowUnencrypted = true"
    # Buat file cockpit.conf
    touch /etc/cockpit/cockpit.conf
    # jalankan perintah echo untuk menambahkan konfigurasi ke dalam file
    echo -e "$config" >> /etc/cockpit/cockpit.conf

    
}

add_cockpit_proxy () {
  # Cek status web server aktif
  if [ "$NGINX_STATUS" = "active" ]; then
    # Fungsi untuk menambahkan konfigurasi proxy ke nginx
    sed -i '/location \/ {/,/}/c\
      location \/ {\n\t\tproxy_pass https:\/\/localhost:9090;\n\t\tproxy_set_header Host $host;\n\t\tproxy_set_header X-Forwarded-Proto $scheme;\n\n\t\t# Required for web sockets to function\n\t\tproxy_http_version 1.1;\n\t\tproxy_buffering off;\n\t\tproxy_set_header Upgrade $http_upgrade;\n\t\tproxy_set_header Connection "upgrade";\n\t\tgzip off;\n\t}' $NGINX_VHOST_DIR
    echo -e "\nMenambahkan script proxy untuk cockpit"
    sleep 2
    systemctl restart nginx
  elif [ "$APACHE2_STATUS" = "active" ]; then
    # Fungsi untuk menambahkan konfigurasi proxy ke apache2
    sed -i '/ProxyPassReverse \/ http:\/\/localhost:9090\//a ProxyPreserveHost On\n\tProxyRequests Off\n\n\t# allow for upgrading to websockets\n\tRewriteEngine On\n\tRewriteCond %{HTTP:UPGRADE} ^WebSocket$ [NC]\n\tRewriteCond %{HTTP:CONNECTION} ^Upgrade$ [NC]\n\tRewriteRule .* ws://localhost:9090/%{REQUEST_URI} [P]' $APACHE2_VHOST_DIR
    echo -e "\nMenambahkan script proxy untuk cockpit"
    sleep 2
    systemctl restart apache2
  fi
}