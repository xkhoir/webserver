
# fungsi untuk menampilkan submenu Mariadb
show_mariadb_submenu() {
    echo "1. Install"
    echo "2. Uninstall"
    echo "3. Kelola Pengguna"
    echo "4. Kelola Database"
    echo "5. Kembali ke menu utama"
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
    secure_install
  else
    echo "Perintah tidak valid."
  fi
}

secure_install(){
    clear
    # Meminta pengguna untuk memasukkan password root
    echo -e -n "\nMasukkan password root baru: "
    read -s ROOT_PASSWORD
    echo

    # Menjalankan mysql_secure_installation secara otomatis
    SECURE_MYSQL=$(expect -c "
    set timeout 10
    spawn mysql_secure_installation

    expect \"Enter current password for root (enter for none):\"
    send \"\r\"

    expect \"Set root password?\"
    send \"Y\r\"

    expect \"New password:\"
    send \"$ROOT_PASSWORD\r\"

    expect \"Re-enter new password:\"
    send \"$ROOT_PASSWORD\r\"

    expect \"Remove anonymous users?\"
    send \"Y\r\"

    expect \"Disallow root login remotely?\"
    send \"Y\r\"

    expect \"Remove test database and access to it?\"
    send \"Y\r\"

    expect \"Reload privilege tables now?\"
    send \"Y\r\"

    expect eof
    ")

    # Menjalankan skrip expect
    echo "$SECURE_MYSQL"
}

# Fungsi untuk mengelola pengguna
manage_user() {
    clear
    show_header
    # Meminta password root 
    echo -e "\n(jika tidak ada silahkan tekan enter)"
    read -sp "Masukkan password root MariaDB: " root_password

    clear
    show_header
    echo "1. Tambah Pengguna"
    echo "2. Ubah Password Pengguna"
    echo "3. Hapus Pengguna"
    echo "4. Kembali"
    echo "======================="
    echo -n "Pilih opsi [1-4]: "
    read choice

    clear
    show_header
    case $choice in
        1)
            read -p "Masukkan nama pengguna baru: " username
            read -sp "Masukkan kata sandi pengguna baru: " password
            echo

            # Membuat query SQL untuk menambahkan pengguna
            query="CREATE USER '$username'@'localhost' IDENTIFIED BY '$password';"
            action="ditambahkan"
            ;;
        2)
            read -p "Masukkan nama pengguna yang akan diubah password: " username
            read -sp "Masukkan kata sandi baru: " password
            echo

            # Membuat query SQL untuk mengubah password pengguna
            query="ALTER USER '$username'@'localhost' IDENTIFIED BY '$password';"
            action="diubah"
            ;;
        3)
            read -p "Masukkan nama pengguna yang akan dihapus: " username

            # Membuat query SQL untuk menghapus pengguna
            query="DROP USER '$username'@'localhost';"
            action="dihapus"
            ;;
        4) return ;;
        *) echo "Opsi tidak valid, silakan coba lagi." ;;
    esac
    # Menjalankan query SQL
    mysql -u root -p"$root_password" -e "$query"

    echo "Pengguna '$username' berhasil $action!"

    echo -e "\nRestart Mariadb service\n"
    systemctl restart mariadb
    sleep 2
}

# Fungsi untuk mengelola database dan binding
manage_database() {
    clear
    show_header
    # Meminta password root MariaDB
    echo -e "\n(jika tidak ada silahkan tekan enter)"
    read -sp "Masukkan password root MariaDB: " root_password

    clear
    show_header
    echo "1. Tambah Database"
    echo "2. Hapus Database"
    echo "3. Kembali"
    echo "======================"
    echo -n "Pilih opsi [1-3]: "
    read choice

    case $choice in
        1)
            read -p "Masukkan nama pengguna: " username
            read -p "Masukkan nama database baru: " database

            # Menambahkan prefix nama pengguna pada nama database
            database_with_prefix="$username"_"$database"

            # Membuat query SQL untuk menambahkan database
            query="CREATE DATABASE $database_with_prefix;"

            # Menjalankan query SQL untuk menambahkan database
            mysql -u root -p"$root_password" -e "$query"

            echo "Database '$database_with_prefix' berhasil ditambahkan!"

            # Membuat query SQL untuk menghubungkan pengguna dengan database
            binding_query="GRANT ALL PRIVILEGES ON $database_with_prefix.* TO '$username'@'localhost';"

            # Menjalankan query SQL untuk menghubungkan pengguna dengan database
            mysql -u root -p"$root_password" -e "$binding_query"

            echo "Pengguna '$username' berhasil dihubungkan dengan database '$database_with_prefix'!"
            ;;
        2)
            read -p "Masukkan nama pengguna: " username
            read -p "Masukkan nama database yang akan dihapus: " database

            # Menambahkan prefix nama pengguna pada nama database
            database_with_prefix="$username"_"$database"

            # Membuat query SQL untuk memisahkan pengguna dari database
            binding_query="REVOKE ALL PRIVILEGES ON $database_with_prefix.* FROM '$username'@'localhost';"
            
            # Menjalankan query SQL untuk memisahkan pengguna dari database
            mysql -u root -p"$root_password" -e "$binding_query"

            echo -e "\nPengguna '$username' berhasil dipisahkan dari database '$database_with_prefix'!"

            # Membuat query SQL untuk menghapus database
            query="DROP DATABASE $database_with_prefix;"

            # Menjalankan query SQL untuk menghapus database
            mysql -u root -p"$root_password" -e "$query"

            echo -e "\nDatabase '$database_with_prefix' berhasil dihapus!"
            ;;
        3) return ;;
        *) echo "Opsi tidak valid, silakan coba lagi." ;;
    esac
    echo -e "\nRestart Mariadb service\n"
    systemctl restart mariadb
    sleep 2
}