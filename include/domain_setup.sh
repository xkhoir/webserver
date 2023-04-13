# Fungsi untuk setup domain dengan Nginx atau Apache dan memperoleh sertifikat SSL dari Let's Encrypt
domain_setup() {
    read -p "Masukkan nama domain kamu :" DOMAIN
    clear
    read -p "Masukkan email untuk domain kamu :" EMAIL
    clear
    cek_php
    clear
    DIRECTORY="/var/www/$DOMAIN/public_html"
    LOG="/var/log/apache2/$DOMAIN"

    # Cek apakah Nginx sedang aktif
    if systemctl is-active --quiet nginx.service; then
        echo -e "\nNginx sudah aktif\m"
        sleep 2
        nginxsetup
    # Cek apakah Apache sedang aktif
    elif systemctl is-active --quiet apache2.service; then
        echo -e "\nApache sudah aktif\n"
        sleep 2
        apachesetup
    else
        # Jika tidak terdapat Nginx atau Apache yang aktif, keluarkan pesan kesalahan
        echo -e"\nNginx atau Apache tidak sedang aktif pada sistem ini. diharap install atau enable service\n"
        sleep 3
        clear
    fi
}

# Fungsi untuk manajemen config Nginx
nginxsetup () {
    # Buat direktori untuk website files
    mkdir -p $DIRECTORY
    echo -e "\nPembuatan Direktori webiste files Sukses\n"
    sleep 1

    #call fungsi addinfo
    addinfo

    #Menyalin file "index.php" ke direktori yang ditentukan dalam variabel $DIRECTORY.
    cp index.php $DIRECTORY

    #mengganti kata "RDOMAIN" pada baris ke-56 dari file "index.php" dengan nilai dari variabel $DOMAIN.
    sed -i "56s/RDOMAIN/$DOMAIN/" $DIRECTORY/index.php
    #mengganti kata "RLOG" pada baris ke-78 dari file "index.php" dengan nilai dari variabel $LOG.
    sed -i "78s/RLOG/$LOG/" $DIRECTORY/index.php
    #mengganti kata "php-fpm7.4" pada baris ke-106 dari file "index.php" dengan nilai dari variabel $versi_terpilih.
    sed -i "106s/php-fpm7.4/$versi_terpilih/" $DIRECTORY/index.php

    # Atur kepemilikan dan izin direktori
    chown -R www-data:www-data $DIRECTORY
    chmod -R 755 $DIRECTORY
    echo -e "\nMengatur kepemilikan dan izin direktori Sukses\n"
    sleep 1

    # call fungsi addvhost Nginx
    manage_vhost "nginx"

    # Aktifkan blok server Nginx
    ln -s /etc/nginx/sites-available/$DOMAIN /etc/nginx/sites-enabled/
    echo -e "\nMengaktifkan blok server $DOMAIN\n"
    sleep 1

    # Uji konfigurasi Nginx
    nginx -t
    echo -e "\nUji konfigurasi Nginx\n"
    sleep 1

    # Restart Nginx
    systemctl restart nginx
    echo -e "\nRestart Nginx\n"
    sleep 1
    clear

    echo "Apakah Anda ingin menginstal SSL untuk $DOMAIN? (y/n)"
    read install_ssl

    if [ "$install_ssl" == "y" ]; then
        # Peroleh sertifikat SSL
        ssl_setup "apache" "$DOMAIN"
    else
        echo -e "\nOK, anda masih tetap dapat menginstall SSL secara manual,\n"
        echo -e "Atau anda dapat menuju submenu apache no.4\n"
        sleep 2
        clear
    fi
}

# Fungsi untuk manajemen config Apache2
apachesetup(){
    # Buat direktori untuk website files
    mkdir -p $DIRECTORY
    echo -e "\nPembuatan Direktori webiste files Sukses"
    sleep 1

    #call fungsi addlog
    addlog

    #call fungsi addinfo
    addinfo

    #Menyalin file "index.php" ke direktori yang ditentukan dalam variabel $DIRECTORY.
    cp index.php $DIRECTORY

    #variabel to string
    # new="$DOMAIN"
    # new1="$LOG"
    # new2="$versi_terpilih"

    #mengganti kata "RDOMAIN" pada baris ke-56 dari file "index.php" dengan nilai dari variabel $DOMAIN.
    sed -i "s#RDOMAIN#$DOMAIN#g" $DIRECTORY/index.php
    #mengganti kata "RLOG" pada baris ke-78 dari file "index.php" dengan nilai dari variabel $LOG.
    sed -i "s#RLOG#$LOG#g" $DIRECTORY/index.php
    #mengganti kata "php-fpm7.4" pada baris ke-106 dari file "index.php" dengan nilai dari variabel $versi_terpilih.
    sed -i "s#php-fpm7.4#$versi_terpilih#g" $DIRECTORY/index.php


    # Atur kepemilikan dan izin direktori
    chown -R www-data:www-data $DIRECTORY
    chmod -R 755 $DIRECTORY
    echo -e "\nMengatur kepemilikan dan izin direktori Sukses"
    sleep 1

    # call fungsi addfile
    manage_vhost "apache2"

    # Aktifkan Virtual Host Apache
    echo -e "\nMengaktifkan $DOMAIN.conf Apache"
    sleep 1
    a2ensite $DOMAIN.conf

    # Disable default Virtual Host Apache
    echo -e "\nDisable 000-default.conf"
    sleep 1
    a2dissite 000-default.conf
    
    # Uji konfigurasi Apache
    echo -e "\nUji konfigurasi Apache"
    sleep 1
    apache2ctl configtest
    
    # Set fcgi FPM
    echo -e "\nUji konfigurasi Apache"
    sleep 1
    a2enmod proxy_fcgi setenvif
    
    # Restart Apache
    echo -e "\nRestart Apache"
    sleep 2
    systemctl restart apache2
    clear

    echo -e"\nApakah Anda ingin menginstal SSL untuk $DOMAIN? (y/n)"
    read install_ssl

    if [ "$install_ssl" == "y" ]; then
        # Peroleh sertifikat SSL
        ssl_setup "apache" "$DOMAIN"
    else
        echo -e "\nOK, anda masih tetap dapat menginstall SSL secara manual,\n"
        echo -e "Atau anda dapat menuju submenu apache no.4\n"
    fi
}

# Fungsi sslsetup untuk mengatur SSL pada server menggunakan Certbot
# Argumen:
#   $1 - apache atau nginx
#   $2 - domain yang akan disertifikasi
ssl_setup() {
    # Cek apakah Certbot sudah terinstal
    echo -e "\ncek certbot"
    sleep 1
    check_package "certbot" "install"
    echo -e "\ncek ufw"
    sleep 1
    check_package "ufw" "install"
    ufw enable

    ufw allow 80
    ufw allow 443
    ufw allow 22
    ufw allow 9090
    ufw allow 3000
    echo -e "\nSukses membuka Port 80,443,22,9090,3000\n"
    sleep 1

    # Cek apakah argumen pertama adalah apache
    if [ "$1" == "apache" ]; then
        # Jika argumen kedua tidak kosong, jalankan Certbot dengan opsi --apache dan -d $2
        if [ -n "$2" ]; then
            sudo certbot --apache -d "$2"
        else
            # Jika argumen kedua kosong, jalankan Certbot dengan opsi --apache saja
            sudo certbot --apache
        fi
    # Cek apakah argumen pertama adalah nginx
    elif [ "$1" == "nginx" ]; then
        # Jika argumen kedua tidak kosong, jalankan Certbot dengan opsi --nginx dan -d $2
        if [ -n "$2" ]; then
            sudo certbot --nginx -d "$2"
        else
            # Jika argumen kedua kosong, jalankan Certbot dengan opsi --nginx saja
            sudo certbot --nginx
        fi
    else
        # Jika argumen pertama bukan apache atau nginx, cetak pesan error
        echo "Usage: sslsetup [apache|nginx] [domain]"
    fi
}

# Fungsi untuk mengecek apakah PHP-FPM telah terpasang dan mengembalikan versi yang terpasang
cek_php() {
  # Cek layanan PHP-FPM yang aktif
  versi=$(systemctl list-units --type=service | grep 'fpm' | grep 'active' | awk '{print $1}' | sed 's/\.service//g')

  if [[ -n "$versi" ]]; then
    echo -e "\nLayanan PHP-FPM tersedia"
    sleep 2
    clear
  else
    echo -e"\nTidak ada layanan PHP-FPM yang tersedia, Install dahulu\n"
    sleep 2
    clear
    exit 0
  fi

  # Tampilkan menu pilihan
  echo -e "\n\nPilih versi PHP-FPM yang akan digunakan:"

  # Pisahkan daftar versi PHP-FPM menjadi array
  IFS=' ' read -ra versi_arr <<< "$versi"

  # Loop untuk menampilkan pilihan menu
  for i in "${!versi_arr[@]}"; do
      echo "$((i+1)). ${versi_arr[i]}"
  done

  # Ambil pilihan dari pengguna
  read -p "Masukkan pilihan: " pilihan

  # Validasi pilihan menggunakan pernyataan case
  case "$pilihan" in
      [1-9]|10)
          versi_terpilih="${versi_arr[$pilihan-1]}"
          echo -e "\nVersi PHP-FPM yang dipilih: $versi_terpilih"
          ;;
      *)
          clear
          echo -e "\nPilihan tidak valid"
          sleep 2
          clear
          return 1
          ;;
  esac
  return 0
}

# Fungsi untuk tambah file log
addlog () {
    # Membuat direktori log untuk domain
    sudo mkdir -p $LOG

    # Membuat file access.log dan error/log
    sudo touch $LOG/access.log
    sudo touch $LOG/error.log

    # Mengubah kepemilikan dan izin direktori log
    sudo chown -R www-data:www-data $LOG
    sudo chmod -R 775 $LOG

    echo -e "\nDirektori file log apache2 untuk $DOMAIN telah berhasil dibuat.\n"
    sleep 2
}

# Fungsi untuk tambah file info.php
addinfo () {
    # fungsi untuk membuat file php untuk info
    echo -n "<?php phpinfo() ?>" | cat > $DIRECTORY/info.php
}

# Fungsi untuk manage vhost webserver
manage_vhost () {
  if [[ $1 == "nginx" ]]; then
    # Buat blok server Nginx
    echo -n "server {
    listen 80;
    listen [::]:80;

    root $DIRECTORY;
    index index.php index.html index.htm;

    server_name $DOMAIN www.$DOMAIN;

    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/$versi_terpilih.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}" | cat > /etc/nginx/sites-available/$DOMAIN
  elif [[ $1 == "apache2" ]]; then
    # Buat Virtual Host Apache
    echo -n "<VirtualHost *:80>
    ServerName $DOMAIN
    ServerAlias www.$DOMAIN
    ServerAdmin webmaster@$DOMAIN
    DocumentRoot $DIRECTORY

    <Directory $DIRECTORY>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>



    ErrorLog ${APACHE_LOG_DIR}/$DOMAIN/error.log
    CustomLog ${APACHE_LOG_DIR}/$DOMAIN/access.log combined
</VirtualHost>" | cat > /etc/apache2/sites-available/$DOMAIN.conf

    echo -e "\nFile vhost $DOMAIN.conf sukses dibuat"
    sleep 4
    
    # Tambah untuk php fpm
    sudo sed -i '13s/.*/    <FilesMatch \\.php$>\n\tSetHandler "proxy:unix:\/run\/php\/'$versi_terpilih'.sock|fcgi:\/\/localhost\/"\n    <\/FilesMatch>/' /etc/apache2/sites-available/$DOMAIN.conf
    sleep 4
  fi
}

# Contoh penggunaan
# manage_vhost "apache2"  # Menambahkan virtual host Apache
# manage_vhost "nginx"   # Menambahkan virtual host Nginx
