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
    check_package "apache2" "install"
    check_package "$package" "install"
    check_package "$package-storaged" "install"
    check_package "$package-packagekit" "install"
    check_package "$package-file-sharing" "install"
    check_package "$package-navigator" "install"
    systemctl enable cockpit

    echo -e "\nMemasang cockpit di domain? (y/n)"
    read CEK

    if [ "$CEK" == "y" ]; then
        # call domain_setup
        domain_setup "cockpit"
    else
        echo -e "\nOK, akses cockpit di localhost anda pada port 9090,"
    fi
  elif [ "$action" == "uninstall" ]; then
    #uninstall cockpit
    check_package "$package" "uninstall"
    echo "" > /etc/cockpit/cockpit.conf
    systemctl restart cockpit.service
  else
    echo "Perintah tidak valid."
  fi
}


