# fungsi untuk menampilkan submenu Wordpress
show_wordpress_submenu() {
    echo "1. Install"
    echo "2. Uninstall"
    echo "3. Kembali ke menu utama"
}

# fungsi untuk proses Wordpress
manage_wordpress() {
    clear
    action=$1
  if [ "$action" == "uninstall" ]; then
    
    domain_input

    restore_backup_docroot
    
    echo -e "\nApps Wordpress pada $DIRECTORY telah dihapus"
    sleep 3

  elif [ "$action" == "install" ]; then

    domain_input

    create_backup_docroot

    var_collect

    #cek paket zip
    check_package "zip" "$action"

    download_wp

    input_config

    set_db

    set_config

    # Menjalankan instalasi WordPress melalui WP-CLI
    wp core install --path=$DIRECTORY --url=$WP_URL --title="$WP_TITLE" --admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL --allow-root

    # Membersihkan file sementara
    rm -rf latest.tar.gz

    show_result
    
    echo -e "\n\nPress any key to continue..."
    read -n 1 -s -r key
  else
    echo "Usage: manage_wordpress [install|uninstall]"
  fi
}

domain_input () {
    # Meminta input dari pengguna untuk DOMAIN
    read -p "Masukkan nama domain wordpress kamu :" DOMAIN
    clear
    # Menentukan direktori instalasi WordPress
    DIRECTORY="/var/www/$DOMAIN/public_html"
}

create_backup_docroot () {
    #Deklarasi direktori backup
    BAC="/var/www/$DOMAIN/backup"
    #Membuat folder backup
    mkdir $BAC
    #Memindah kan semua isi di folder dockroot web ke folder backup
    mv $DIRECTORY/* $BAC
}

restore_backup_docroot () {
    #Deklarasi direktori backup
    BAC="/var/www/$DOMAIN/backup"
    #Menghapus semua file yang ada di dalam docroot web
    rm -rf $DIRECTORY/*
    #Memindah kan semua isi di folder backup ke docroot web
    mv $BAC/* $DIRECTORY
    #Menghapus folder backup
    rm -rf $BAC
}

var_collect () {
    # Nilai default untuk variabel database
    DEFAULT_DB_NAME="wordpress"
    DEFAULT_DB_USER="wp-db-admin"
    DEFAULT_DB_PASSWORD="123456"
    DEFAULT_DB_HOST="localhost"

    # Nilai default untuk variabel WordPress
    DEFAULT_WP_URL="https://$DOMAIN"
    DEFAULT_WP_TITLE="Judul_Situs"
    DEFAULT_WP_ADMIN_USER="wp_admin"
    DEFAULT_WP_ADMIN_PASSWORD="wp_pass"
    DEFAULT_WP_ADMIN_EMAIL="wp@$DOMAIN"
    DEFAULT_DB_PREFIX="wp_"
}

download_wp () {
    # Mengunduh dan menginstal WordPress
    wget https://wordpress.org/latest.tar.gz
    tar -xvf latest.tar.gz
    sudo mv wordpress/* $DIRECTORY
    sudo chown -R www-data:www-data $DIRECTORY
    sudo chmod -R 755 $DIRECTORY
}

input_config () {
    # Meminta input dari pengguna untuk variabel database
    read -p "Masukkan nama database Default: [$DEFAULT_DB_NAME]: " DB_NAME
    DB_NAME=${DB_NAME:-$DEFAULT_DB_NAME}

    read -p "Masukkan nama pengguna database Default: [$DEFAULT_DB_USER]: " DB_USER
    DB_USER=${DB_USER:-$DEFAULT_DB_USER}

    read -sp "Masukkan kata sandi database Default: [$DEFAULT_DB_PASSWORD]: " DB_PASSWORD
    DB_PASSWORD=${DB_PASSWORD:-$DEFAULT_DB_PASSWORD}
    echo
    read -p "Masukkan host database Default: [$DEFAULT_DB_HOST]: " DB_HOST
    DB_HOST=${DB_HOST:-$DEFAULT_DB_HOST}

    read -p "Masukkan database table prefix: [$DEFAULT_DB_PREFIX]: " DB_PREFIX
    DB_PREFIX=${DB_PREFIX:-$DEFAULT_DB_PREFIX}

    clear
    read -p "Masukkan judul situs WordPress Default: [$DEFAULT_WP_TITLE]: " WP_TITLE
    WP_TITLE=${WP_TITLE:-$DEFAULT_WP_TITLE}

    read -p "Masukkan nama pengguna admin WordPress Default: [$DEFAULT_WP_ADMIN_USER]: " WP_ADMIN_USER
    WP_ADMIN_USER=${WP_ADMIN_USER:-$DEFAULT_WP_ADMIN_USER}

    read -sp "Masukkan kata sandi admin WordPress Default: [$DEFAULT_WP_ADMIN_PASSWORD]: " WP_ADMIN_PASSWORD
    WP_ADMIN_PASSWORD=${WP_ADMIN_PASSWORD:-$DEFAULT_WP_ADMIN_PASSWORD}
    echo
    read -p "Masukkan email admin WordPress Default: [$DEFAULT_WP_ADMIN_EMAIL]: " WP_ADMIN_EMAIL
    WP_ADMIN_EMAIL=${WP_ADMIN_EMAIL:-$DEFAULT_WP_ADMIN_EMAIL}

    # Meminta input dari pengguna untuk opsi Ketampakan di Mesin Pencari
    # read -p "Apakah Anda ingin menghalangi mesin pencari untuk mengindeks situs ini? (y/n) " ROBOTS_OPTION
}

set_db () {
    # Pengecekan pengguna root pada database
    ROOT_ACCESS=$(mysql -u root -e "SELECT user FROM mysql.user WHERE user='root' AND host='localhost';" 2>&1)
    while [[ $ROOT_ACCESS == *"Access denied for user 'root'@'localhost'"* ]]; do
        echo "User root pada database terdapat kata sandi !!" 
        read -sp "Masukkan kata sandi root:"  ROOT_PASSWORD	
        echo
        ROOT_ACCESS=$(mysql -u root -p$ROOT_PASSWORD -e "SELECT user FROM mysql.user WHERE user='root' AND host='localhost';" 2>&1)
    done

    # Mengecek apakah database sudah ada
    EXISTING_DB=$(mysql -u root -p$ROOT_PASSWORD -sN -e "SELECT COUNT(*) FROM information_schema.SCHEMATA WHERE SCHEMA_NAME = '$DB_NAME';")
    if [ "$EXISTING_DB" -eq 0 ]; then
        # Membuat database
        mysql -u root -p$ROOT_PASSWORD -e "CREATE DATABASE $DB_NAME;"
    fi

    # Mengecek apakah pengguna sudah ada di database
    EXISTING_USER=$(mysql -u root -p$ROOT_PASSWORD -sN -e "SELECT COUNT(*) FROM mysql.user WHERE user = '$DB_USER';")
    if [ "$EXISTING_USER" -eq 0 ]; then
        # Membuat pengguna
        mysql -u root -p$ROOT_PASSWORD -e "CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD';"
    fi

    # Memberikan hak akses ke database untuk pengguna
    mysql -u root -p$ROOT_PASSWORD -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';"
    mysql -u root -p$ROOT_PASSWORD -e "FLUSH PRIVILEGES;"
}

set_config () {
    # Konfigurasi WordPress
    sudo cp $DIRECTORY/wp-config-sample.php $DIRECTORY/wp-config.php
    sudo sed -i "s/database_name_here/$DB_NAME/" $DIRECTORY/wp-config.php
    sudo sed -i "s/username_here/$DB_USER/" $DIRECTORY/wp-config.php
    sudo sed -i "s/password_here/$DB_PASSWORD/" $DIRECTORY/wp-config.php
    sudo sed -i "s/localhost/$DB_HOST/" $DIRECTORY/wp-config.php
    sudo sed -i "s/wp_/$DB_PREFIX/" $DIRECTORY/wp-config.php

    # Mengatur informasi situs WordPress
    sudo sed -i "s/http:\/\/example.com/$WP_URL/" $DIRECTORY/wp-config.php
    sudo sed -i "s/My Blog/$WP_TITLE/" $DIRECTORY/wp-config.php

    # Mendapatkan output dari curl command
    output=$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)

    # Memisahkan baris-baris output
    IFS=$'\n' read -rd '' -a lines <<< "$output"

    # Menentukan baris yang akan dihapus
    start_line=51
    end_line=58

    # Menghapus baris 51-58 di wp-config.php
    sed -i "${start_line},${end_line}d" $DIRECTORY/wp-config.php

    # Mengganti baris yang dihapus dengan output perulangan
    for ((i=0; i<${#lines[@]}; i++)); do
        line_number=$((start_line+i))
        sed -i "${line_number}i${lines[i]}" $DIRECTORY/wp-config.php
    done

    # Menambahkan opsi Ketampakan di Mesin Pencari
    # if [ "$ROBOTS_OPTION" == "y" ]; then
    #     echo "User-agent: *" | sudo tee -a $DIRECTORY/robots.txt
    #     echo "Disallow: /" | sudo tee -a $DIRECTORY/robots.txt
    # fi
}

show_result () {
    # Tampilan hasil setiap inputan
    clear
    echo "========================================="
    echo "  Hasil Konfigurasi Instalasi WordPress  "
    echo "      Silahkan dicopy untuk Disimpan     "
    echo "========================================="
    echo -e "WP Admin Silahkan akses\t: $WP_URL/wp-admin"
    echo -e "Database Silahkan akses\t: $WP_URL/phpmyadmin"
    echo -e "Wordpress Directory \t: $DIRECTORY"
    echo "========================================="
    echo -e "Nama Database\t\t: $DB_NAME"
    echo -e "Nama Pengguna Database\t: $DB_USER"
    echo -e "Kata Sandi Database\t: $DB_PASSWORD"
    echo "========================================="
    echo -e "Nama Pengguna Admin WordPress\t: $WP_ADMIN_USER"
    echo -e "Kata Sandi Admin WordPress\t: $WP_ADMIN_PASSWORD"
    echo -e "Email Admin WordPress\t\t: $WP_ADMIN_EMAIL"
    echo -e "Opsi Ketampakan di Mesin Pencari: $ROBOTS_OPTION"
    echo "========================================="
    sleep 5
}