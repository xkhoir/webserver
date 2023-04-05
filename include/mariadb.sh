
# fungsi untuk menampilkan submenu Mariadb
show_mariadb_submenu() {
    echo "1. Install"
    echo "2. Uninstall"
    echo "3. Kelola User Database"
    echo "4. Kembali ke menu utama"
}

# fungsi untuk proses Mariadb
manage_mariadb() {
    clear
    package="mariadb"
    action=$1
  if [ "$action" == "uninstall" ]; then
    #parsing data ke fungsi check_package
    check_package "$package" "uninstall"
  elif [ "$action" == "install" ]; then
    #parsing data ke fungsi check_package
    check_package "$package-server" "install"
    
    #Setup install mariadb
    # echo -e "\nSetup mariadb ...\n"
    # # Minta password root MySQL dari pengguna
    # echo "Masukkan password root MySQL:"
    # read -s MYSQL_ROOT_PASSWORD
    
    # # Set password root MySQL ke dalam variabel lingkungan
    # export MYSQL_PWD=$MYSQL_ROOT_PASSWORD
    
    # Jalankan script mysql_secure_installation dengan opsi --no-root-password
    # echo "Menjalankan pengamanan instalasi MySQL..."
    # echo -e "n\ny\ny\ny\ny" | mysql_secure_installation
    # sleep 20
    # Hapus variabel lingkungan password root MySQL
    # unset MYSQL_PWD
    
    # echo "Instalasi MySQL telah diamankan."
  else
    echo "Perintah tidak valid."
  fi
}

# fungsi untuk menambah, mengubah, atau menghapus user di MariaDB
manage_user() {
    # Minta nama user dan tindakan yang diinginkan (add, modify, atau delete)
    clear
    show_header
    echo "Masukkan nama user yang ingin dikelola:"
    read USER
    clear
    show_header
    echo "Masukkan tindakan yang ingin dilakukan (add, modify, atau delete):"
    read ACTION

    # Minta password jika tindakan adalah menambah atau mengubah user
    if [[ "$ACTION" == "add" || "$ACTION" == "modify" ]]; then
        clear
        show_header
        echo "Masukkan password baru:"
        read -s PASSWORD
    fi

    # Jalankan perintah sesuai dengan tindakan yang diminta
    clear
    show_header
    case "$ACTION" in
        "add")
            echo -e "\nMasukkan password root Database (jika tidak ada silahkan tekan enter)"
            echo "CREATE USER '$USER'@'localhost' IDENTIFIED BY '$PASSWORD';" | mysql -u root -p
            echo -e "\nMasukkan kembali password root Database (jika tidak ada silahkan tekan enter)"
            echo "GRANT ALL PRIVILEGES ON *.* TO '$USER'@'localhost' WITH GRANT OPTION;" | mysql -u root -p
            echo -e "\nUser $USER telah di tambahkan ke Database"
            sleep 2
            ;;
        "modify")
            echo -e "\nMasukkan password root Database (jika tidak ada silahkan tekan enter)"
            echo "FLUSH PRIVILEGES;" | mysql -u root -p
            echo -e "\nMasukkan kembali password root Database (jika tidak ada silahkan tekan enter)"
            echo "ALTER USER '$USER'@'localhost' IDENTIFIED BY '$PASSWORD';" | mysql -u root -p
            echo -e "\nPassword $USER telah teganti"
            sleep 2
            ;;
        "delete")
            echo -e "\nMasukkan password root Database (jika tidak ada silahkan tekan enter)"
            echo "DROP USER '$USER'@'localhost';" | mysql -u root -p
            echo -e "\nUser $USER telah dihapus"
            sleep 2
            ;;
        *)  
            echo "Tindakan tidak valid."
            ;;
    esac
    echo -e "\nRestart Mariadb service\n"
    systemctl restart mariadb
    sleep 2
}