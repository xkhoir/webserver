# Fungsi untuk mengecek apakah PHP-FPM telah terpasang dan mengembalikan versi yang terpasang
#!/bin/bash

function cek_php() {
  # Cek layanan PHP-FPM yang aktif
  versi=$(systemctl list-units --type=service | grep 'fpm' | grep 'active' | awk '{print $1}' | sed 's/\.service//g')

  # Tampilkan daftar versi PHP-FPM yang aktif
  if [[ -n "$versi" ]]; then
    echo "Daftar Versi PHP-FPM yang aktif: $versi"
  else
    echo "Tidak ada layanan PHP-FPM yang tersedia, Install dulu"
    exit 0
  fi

  # Tampilkan menu pilihan
  echo "Pilih versi PHP-FPM yang akan digunakan:"

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
          echo "Versi PHP-FPM yang dipilih: $versi_terpilih"
          ;;
      *)
          echo "Pilihan tidak valid"
          return 1
          ;;
  esac

  return 0
}

# Fungsi untuk setup domain dengan Nginx atau Apache dan memperoleh sertifikat SSL dari Let's Encrypt
domain_setup() {
    read -p "Masukkan nama domain kamu :" DOMAIN
    cek_php
    DIRECTORY="/var/www/$DOMAIN/public_html"
    LOG="/var/log/apache/$DOMAIN"

    # Cek apakah Apache atau Nginx terpasang pada sistem
    if [[ $(dpkg -l | grep -w nginx | wc -l) -eq 1 ]]; then
        nginxsetup
    elif [[ $(dpkg -l | grep -w apache2 | wc -l) -eq 1 ]]; then
        apachesetup
    else
        # Jika tidak terdapat Nginx atau Apache, keluarkan pesan kesalahan
        echo "Nginx atau Apache tidak terpasang pada sistem ini."
    fi
}

nginxsetup () {
    # Buat direktori untuk website files
    mkdir -p $DIRECTORY

    # Atur kepemilikan dan izin direktori
    chown -R www-data:www-data $DIRECTORY
    chmod -R 755 $DIRECTORY

    # Buat blok server Nginx
    cat > /etc/nginx/sites-available/$DOMAIN << EOF
server {
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
}
EOF

    # Aktifkan blok server Nginx
    ln -s /etc/nginx/sites-available/$DOMAIN /etc/nginx/sites-enabled/

    # Uji konfigurasi Nginx
    nginx -t

    # Restart Nginx
    systemctl restart nginx

    # Uji konfigurasi Nginx
    nginx -t

    # Restart Nginx
    systemctl restart nginx

    echo "Apakah Anda ingin menginstal SSL untuk $DOMAIN? (y/n)"
    read install_ssl

    if [ "$install_ssl" == "y" ]; then
        # Peroleh sertifikat SSL
        ssl_setup "apache" "$DOMAIN"
    else
        echo -e "\nOK, anda masih tetap dapat menginstall SSL secara manual,\n"
        echo -e "Atau anda dapat menuju submenu apache no.4\n"
    fi
}

apachesetup(){
    # Buat direktori untuk website files
    mkdir -p $DIRECTORY
    mkdir -p $LOG

    # Atur kepemilikan dan izin direktori
    chown -R www-data:www-data $DIRECTORY
    chmod -R 755 $DIRECTORY

    # Buat blok Virtual Host Apache
    cat > /etc/apache2/sites-available/$DOMAIN.conf << EOF
<VirtualHost *:80>
    ServerName $DOMAIN
    ServerAlias www.$DOMAIN
    DocumentRoot $DIRECTORY

    <Directory $DIRECTORY>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    <FilesMatch \.php$>
        SetHandler 'proxy:unix:/run/php/$versi_terpilih.sock|fcgi://localhost/'
    </FilesMatch>

    ErrorLog ${APACHE_LOG_DIR}/$DOMAIN/error.log
    CustomLog ${APACHE_LOG_DIR}/$DOMAIN/access.log combined
</VirtualHost>
EOF

    # Aktifkan Virtual Host Apache
    a2ensite $DOMAIN.conf

    # Disable default Virtual Host Apache
    a2dissite 000-default.conf

    # Uji konfigurasi Apache
    apache2ctl config
    
    # Restart Apache
    systemctl restart apache2
    
    # Uji konfigurasi Apache
    apache2ctl configtest
    
    # Restart Apache
    systemctl restart apache2

    echo "Apakah Anda ingin menginstal SSL untuk $DOMAIN? (y/n)"
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
    check_package "certbot" "install"
    check_package "ufw" "install"

    ufw allow 80 443 22 9090

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