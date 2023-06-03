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

    set_config

    # Menjalankan instalasi WordPress melalui WP-CLI
    wp core install --path=$DIRECTORY --url=$WP_URL --title="$WP_TITLE" --admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL --allow-root

    # Membersihkan file sementara
    rm -rf latest.tar.gz

    show_result

    echo -e "\nApp Wordpress telah terinstall di $DIRECTORY"
    echo -e "\nSilahkan akses $DOMAIN"
    sleep 5
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
    read -p "Apakah Anda ingin menghalangi mesin pencari untuk mengindeks situs ini? (y/n) " ROBOTS_OPTION
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

    # Mengenerate kunci rahasia WordPress
    AUTH_KEY=$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)
    AUTH_KEY=${AUTH_KEY//\'/\\\'}
    AUTH_KEY=${AUTH_KEY//$'\n'/}

    # Menambahkan kunci rahasia WordPress
    sudo sed -i "/#@-/a define( 'AUTH_KEY',         '$AUTH_KEY' );" $DIRECTORY/wp-config.php
    sudo sed -i "/#@-/a define( 'SECURE_AUTH_KEY',  '$AUTH_KEY' );" $DIRECTORY/wp-config.php
    sudo sed -i "/#@-/a define( 'LOGGED_IN_KEY',    '$AUTH_KEY' );" $DIRECTORY/wp-config.php
    sudo sed -i "/#@-/a define( 'NONCE_KEY',        '$AUTH_KEY' );" $DIRECTORY/wp-config.php
    sudo sed -i "/#@-/a define( 'AUTH_SALT',        '$AUTH_KEY' );" $DIRECTORY/wp-config.php
    sudo sed -i "/#@-/a define( 'SECURE_AUTH_SALT', '$AUTH_KEY' );" $DIRECTORY/wp-config.php
    sudo sed -i "/#@-/a define( 'LOGGED_IN_SALT',   '$AUTH_KEY' );" $DIRECTORY/wp-config.php
    sudo sed -i "/#@-/a define( 'NONCE_SALT',       '$AUTH_KEY' );" $DIRECTORY/wp-config.php

    # Menambahkan opsi Ketampakan di Mesin Pencari
    if [ "$ROBOTS_OPTION" == "y" ]; then
        echo "User-agent: *" | sudo tee -a $DIRECTORY/robots.txt
        echo "Disallow: /" | sudo tee -a $DIRECTORY/robots.txt
    fi
}

show_result () {
    # Tampilan hasil setiap inputan
    clear
    echo "======================================="
    echo "   Hasil Konfigurasi Instalasi WordPress"
    echo "======================================="
    echo "Nama Database: $DB_NAME"
    echo "Nama Pengguna Database: $DB_USER"
    echo "Kata Sandi Database: $DB_PASSWORD"
    echo "Host Database: $DB_HOST"
    echo "Domain: $DOMAIN"
    echo "Judul Situs WordPress: $WP_TITLE"
    echo "Nama Pengguna Admin WordPress: $WP_ADMIN_USER"
    echo "Kata Sandi Admin WordPress: $WP_ADMIN_PASSWORD"
    echo "Email Admin WordPress: $WP_ADMIN_EMAIL"
    echo "Opsi Ketampakan di Mesin Pencari: $ROBOTS_OPTION"
    echo "======================================="
}
