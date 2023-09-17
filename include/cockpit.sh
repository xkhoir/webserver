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
    check_package "$package-packagekit" "$action"
    check_package "$package-file-sharing" "$action"
    check_package "$package-navigator" "$action"
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
        clear
        echo -e "\nServer Akan reboot dalam 3 detik\n"
        sleep 3
        reboot
    else
        echo -e "\nOK, akses cockpit di localhost anda pada port 9090,"
    fi
  elif [ "$action" == "uninstall" ]; then
    #uninstall cockpit
    check_package "$package" "$action"
    echo "" > /etc/cockpit/cockpit.conf
    echo "" > /etc/NetworkManager/conf.d/10-globally-managed-devices.conf
    nmcli con delete con-name fake
    systemctl restart cockpit.service
    systemctl restart NetworkManager
    clear
    echo -e "\nServer Akan reboot dalam 3 detik\n"
    sleep 3
    reboot
  else
    echo "Perintah tidak valid."
  fi
}


