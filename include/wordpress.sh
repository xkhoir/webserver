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
    # check_package "sendmail" "uninstall"
    # check_package "ssmtp" "uninstall"
    core_wp-uninstall
    restore_backup_docroot
    # WP-CLI sudah terinstal, lakukan proses uninstall
    echo "Menghapus WP-CLI..."
    sudo rm -rf /usr/local/bin/wp
    echo "WP-CLI berhasil dihapus."

    echo -e "\nApps Wordpress pada $DIRECTORY telah dihapus"
    echo -e "\nPress any key to continue..."
    read -n 1 -s -r key

  elif [ "$action" == "install" ]; then
    domain_input
    # check_package "sendmail" "install"
    # check_package "ssmtp" "install"
    create_backup_docroot
    # WP-CLI belum terinstal, lakukan proses instalasi
    echo "Menginstal WP-CLI..."
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
    echo "WP-CLI berhasil diinstal."
    db_wp-config
    core_wp-install
    show_result
    echo -e "\nPress any key to continue..."
    read -n 1 -s -r key
  else
    echo "Usage: manage_wordpress [install|uninstall]"
  fi
}

db_wp-config () {
    clear
    # Input untuk wp core config
    read -p "Masukkan nama database (default: wordpress): " DATABASE_NAME
    DATABASE_NAME=${DATABASE_NAME:-wordpress}
    read -p "Masukkan nama pengguna database (default: dbadmin): " DATABASE_USER
    DATABASE_USER=${DATABASE_USER:-dbadmin}
    read -s -p "Masukkan kata sandi database: " DATABASE_PASSWORD
    echo
    # Menambahkan prefix nama pengguna pada nama database
    DATABASE_WITH_PREFIX="$DATABASE_USER"_"$DATABASE_NAME"
    read -p "Masukkan host database (default: localhost): " DATABASE_HOST
    DATABASE_HOST=${DATABASE_HOST:-localhost}
    read -p "Masukkan awalan tabel database (default: wp_): " TABLE_PREFIX
    TABLE_PREFIX=${TABLE_PREFIX:-wp_}
    clear
    set_db
    clear
    wp core download --path="$DIRECTORY" --skip-content --allow-root
    sleep 2
    wp core config --path="$DIRECTORY" --dbname="$DATABASE_WITH_PREFIX" --dbuser="$DATABASE_USER" --dbpass="$DATABASE_PASSWORD" --dbhost="$DATABASE_HOST" --dbprefix="$TABLE_PREFIX" --allow-root
    sleep 2
    wp db create --path="$DIRECTORY" --allow-root
    sleep 2
}

core_wp-install () {
    clear
    # Input untuk wp core install
    WEBSITE_URL=${WEBSITE_URL:-https://$DOMAIN}
    read -p "Masukkan judul situs WordPress (default: Myblog): " WEBSITE_TITLE
    WEBSITE_TITLE=${WEBSITE_TITLE:-Myblog}
    read -p "Masukkan nama pengguna administrator (default: Admin): " ADMIN_USERNAME
    ADMIN_USERNAME=${ADMIN_USERNAME:-Admin}
    read -s -p "Masukkan kata sandi administrator: " ADMIN_PASSWORD
    echo
    read -p "Masukkan alamat email administrator (default: webmin@$DOMAIN): " ADMIN_EMAIL
    ADMIN_EMAIL=${ADMIN_EMAIL:-webmin@$DOMAIN}
    chmod -R 755 $DIRECTORY
    chown -R www-data:www-data $DIRECTORY
    clear
    echo -e "\nWp core install. please wait..."
    wp core install --path="$DIRECTORY" --url="$WEBSITE_URL" --title="$WEBSITE_TITLE" --admin_user="$ADMIN_USERNAME" --admin_password="$ADMIN_PASSWORD" --admin_email="$ADMIN_EMAIL" --allow-root
    echo "Set default theme"
    wp theme install twentytwentythree --path="$DIRECTORY" --activate --allow-root
}

core_wp-uninstall () {
    # Minta input untuk menghapus atau melewati penghapusan basis data
    read -p "Apakah Anda ingin menghapus basis data juga? (y/n): " DELETE_DATABASE

    # Jika user memilih untuk menghapus basis data
    if [[ $DELETE_DATABASE == "y" ]]; then
        # Jalankan perintah untuk menghapus situs WordPress dan basis data
        wp site empty --path="$DIRECTORY" --yes --url=$WEBSITE_URL --allow-root
        sleep 2
    else
        # Jalankan perintah untuk hanya menghapus situs WordPress tanpa menghapus basis data
        wp site empty --path="$DIRECTORY" --yes --url=$WEBSITE_URL --skip-delete-db --allow-root
        sleep 2
    fi
}

domain_input () {
    # Meminta input dari pengguna untuk DOMAIN
    read -p "Masukkan nama domain wordpress kamu :" DOMAIN
    WEBSITE_URL=${WEBSITE_URL:-https://$DOMAIN}
    clear
    # Menentukan direktori instalasi WordPress
    DIRECTORY="/var/www/$DOMAIN"
}

create_backup_docroot () {
    #Deklarasi direktori backup
    BAC="/var/www/$DOMAIN/backup"
    #Membuat folder backup
    mkdir $BAC
    #Memindah kan semua isi di folder dockroot web ke folder backup
    mv $DIRECTORY/* $BAC
    echo "Default Page Berhasil di backup"
    sleep 2
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
    echo "Default Page Berhasil di restore"
}

set_db () {
    # Pengecekan pengguna root pada database
    ROOT_ACCESS=$(mysql -u root -e "SELECT user FROM mysql.user WHERE user='root' AND host='localhost';" 2>&1)
    while [[ $ROOT_ACCESS == *"Access denied for user 'root'@'localhost'"* ]]; do
        echo "User root pada database terdapat kata sandi !!"
        read -sp "Masukkan kata sandi root:"  ROOT_PASSWORD
        echo
        SET_ROOT_PASS="-p$ROOT_PASSWORD"
        ROOT_ACCESS=$(mysql -u root $SET_ROOT_PASS -e "SELECT user FROM mysql.user WHERE user='root' AND host='localhost';" 2>&1)
    done
    #Mengecek apakah database sudah ada
    EXISTING_DB=$(mysql -u root $SET_ROOT_PASS -sN -e "SELECT COUNT(*) FROM information_schema.SCHEMATA WHERE SCHEMA_NAME = '$DATABASE_WITH_PREFIX';")
    if [ "$EXISTING_DB" -eq 0 ]; then
        # Membuat database
        mysql -u root $SET_ROOT_PASS -e "CREATE DATABASE $DATABASE_WITH_PREFIX;"
        echo "Create database $DATABASE_WITH_PREFIX success"
        sleep 2
    fi

    # Mengecek apakah pengguna sudah ada di database
    EXISTING_USER=$(mysql -u root $SET_ROOT_PASS -sN -e "SELECT COUNT(*) FROM mysql.user WHERE user = '$DATABASE_USER';")
    if [ "$EXISTING_USER" -eq 0 ]; then
        # Membuat pengguna
        mysql -u root $SET_ROOT_PASS -e "CREATE USER '$DATABASE_USER'@'localhost' IDENTIFIED BY '$DATABASE_PASSWORD';"
        echo "Create user $DATABASE_USER success"
        sleep 2
    fi

    # Memberikan hak akses ke database untuk pengguna
    mysql -u root $SET_ROOT_PASS -e "GRANT ALL PRIVILEGES ON $DATABASE_WITH_PREFIX.* TO '$DATABASE_USER'@'localhost';"
    mysql -u root $SET_ROOT_PASS -e "FLUSH PRIVILEGES;"
    echo "Set privilage for $DATABASE_USER to $DATABASE_WITH_PREFIX success"
    sleep 2
    mysql -u root $SET_ROOT_PASS -e "DROP DATABASE $DATABASE_WITH_PREFIX;"

}

show_result () {
    # Tampilan hasil setiap inputan
    clear
    echo "========================================="
    echo "  Hasil Konfigurasi Instalasi WordPress  "
    echo "      Silahkan dicopy untuk Disimpan     "
    echo "========================================="
    echo -e "WP Admin Silahkan akses\t: $WEBSITE_URL/wp-admin"
    echo -e "Database Silahkan akses\t: $WEBSITE_URL/phpmyadmin"
    echo -e "Wordpress Directory \t: $DIRECTORY"
    echo "========================================="
    echo -e "Nama Database\t\t: $DATABASE_WITH_PREFIX"
    echo -e "Nama Pengguna Database\t: $DATABASE_USER"
    echo -e "Kata Sandi Database\t: $DATABASE_PASSWORD"
    echo "========================================="
    echo -e "Nama Pengguna Admin WordPress\t: $ADMIN_USERNAME"
    echo -e "Kata Sandi Admin WordPress\t: $ADMIN_PASSWORD"
    echo -e "Email Admin WordPress\t\t: $ADMIN_EMAIL"
    echo "========================================="
}