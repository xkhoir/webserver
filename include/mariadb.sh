
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

# Fungsi untuk mengelola pengguna
manage_user() {
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
    echo -e "\nMasukkan password root Database (jika tidak ada silahkan tekan enter)"
    # Menjalankan query SQL
    mysql -u root -p -e "$query"

    echo "Pengguna '$username' berhasil $action!"

    echo -e "\nRestart Mariadb service\n"
    systemctl restart mariadb
    sleep 2
}

# Fungsi untuk mengelola database dan binding
manage_database() {
    echo "=== KELOLA DATABASE ==="
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

            echo -e "\nMasukkan password root Database (jika tidak ada silahkan tekan enter)"
            # Menjalankan query SQL untuk menambahkan database
            mysql -u root -p -e "$query"

            echo "Database '$database_with_prefix' berhasil ditambahkan!"

            # Membuat query SQL untuk menghubungkan pengguna dengan database
            binding_query="GRANT ALL PRIVILEGES ON $database_with_prefix.* TO '$username'@'localhost';"

            echo -e "\nMasukkan kembali password root Database (jika tidak ada silahkan tekan enter)"
            # Menjalankan query SQL untuk menghubungkan pengguna dengan database
            mysql -u root -p -e "$binding_query"

            echo "Pengguna '$username' berhasil dihubungkan dengan database '$database_with_prefix'!"
            ;;
        2)
            read -p "Masukkan nama pengguna: " username
            read -p "Masukkan nama database yang akan dihapus: " database

            # Menambahkan prefix nama pengguna pada nama database
            database_with_prefix="$username"_"$database"

            # Membuat query SQL untuk memisahkan pengguna dari database
            binding_query="REVOKE ALL PRIVILEGES ON $database_with_prefix.* FROM '$username'@'localhost';"
            
            echo -e "\nMasukkan password root Database (jika tidak ada silahkan tekan enter)"
            # Menjalankan query SQL untuk memisahkan pengguna dari database
            mysql -u root -p -e "$binding_query"

            echo -e "\nPengguna '$username' berhasil dipisahkan dari database '$database_with_prefix'!"

            # Membuat query SQL untuk menghapus database
            query="DROP DATABASE $database_with_prefix;"

            echo -e "\nMasukkan kembali password root Database (jika tidak ada silahkan tekan enter)"
            # Menjalankan query SQL untuk menghapus database
            mysql -u root -p -e "$query"

            echo -e "\nDatabase '$database_with_prefix' berhasil dihapus!"
            ;;
        3) return ;;
        *) echo "Opsi tidak valid, silakan coba lagi." ;;
    esac
    echo -e "\nRestart Mariadb service\n"
    systemctl restart mariadb
    sleep 2
}