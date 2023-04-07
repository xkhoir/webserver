# Fungsi untuk mengecek apakah PHP-FPM telah terpasang dan mengembalikan versi yang terpasang
function cek_php() {
  # Cek layanan PHP-FPM yang aktif
  versi=$(systemctl list-units --type=service | grep 'fpm' | grep 'active' | awk '{print $1}' | sed 's/\.service//g')

  # Tampilkan daftar versi PHP-FPM yang aktif
  if [[ -n "$versi" ]]; then
    echo "Daftar Versi PHP-FPM yang aktif: $versi"
    sleep 2
    clear
  else
    echo "Tidak ada layanan PHP-FPM yang tersedia, Install dulu"
    sleep 2
    clear
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
          sleep 2
          clear
          return 1
          ;;
  esac
  return 0
}

# Fungsi untuk setup domain dengan Nginx atau Apache dan memperoleh sertifikat SSL dari Let's Encrypt
domain_setup() {
    read -p "Masukkan nama domain kamu :" DOMAIN
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

nginxsetup () {
    # Buat direktori untuk website files
    mkdir -p $DIRECTORY
    echo -e "\nPembuatan Direktori webiste files Sukses\n"
    sleep 1

    # Buat file php untuk info
    cat > $DIRECTORY/info.php << EOF
    <?php phpinfo() ?>
EOF

    # Buat file php unuk test
    cat > $DIRECTORY/index.php << EOF
<!DOCTYPE html>
<html>
<head>
	<title>Verifikasi Domain Terinstall</title>
	<style>
		body {
			font-family: Arial, sans-serif;
			background-color: #f7f7f7;
			margin: 0;
			padding: 0;
		}
		.container {
			max-width: 800px;
			margin: 0 auto;
			padding: 20px;
		}
		h1 {
			text-align: center;
			color: #4CAF50;
		}
		p {
			font-size: 18px;
			line-height: 1.5;
			color: #333;
			margin-bottom: 20px;
		}
		.success {
			color: #4CAF50;
			font-weight: bold;
		}
		.failure {
			color: #F44336;
			font-weight: bold;
		}
	</style>
</head>
<body>
	<div class="container">
		<h1>Verifikasi Domain Terinstall</h1>
		<p>Selamat! Domain <span class="success">$DOMAIN</span> telah terinstall dengan sukses!</p>
		<?php
			if (function_exists('phpversion')) {
				echo '<p>Versi PHP yang terpasang adalah <span class="success">' . phpversion() . '</span>.</p>';
			} else {
				echo '<p class="failure">PHP tidak terpasang pada server ini.</p>';
			}

			if (function_exists('php_sapi_name') && (substr(php_sapi_name(), 0, 3) == 'fpm')) {
				echo '<p>Versi FPM yang aktif adalah <span class="success">' . php_sapi_name() . '</span>.</p>';
			} else {
				echo '<p class="failure">FPM tidak terpasang atau tidak aktif pada server ini.</p>';
			}
		?>
		<p>Anda sekarang dapat memulai untuk mengembangkan website Anda.</p>
		<p>Jangan ragu untuk menghubungi kami jika Anda memerlukan bantuan.</p>
		<p>Terima kasih telah memilih layanan kami.</p>
	</div>
</body>
</html>
EOF
    echo -e "\nPembuatan Direktori webiste files Sukses\n"
    sleep 1

    # Atur kepemilikan dan izin direktori
    chown -R www-data:www-data $DIRECTORY
    chmod -R 755 $DIRECTORY
    echo -e "\nMengatur kepemilikan dan izin direktori Sukses\n"
    sleep 1

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
    echo -e "\nPembuatan blok server $DOMAIN Sukses\n"
    sleep 1

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

apachesetup(){
    # Buat direktori untuk website files
    mkdir -p $DIRECTORY
    mkdir -p $LOG
    echo -e "\nPembuatan Direktori webiste files Sukses\n"
    sleep 1

    # Buat file php untuk info
    cat > $DIRECTORY/info.php << EOF
<?php phpinfo() ?>
EOF
    # Buat file php untuk test
    cat > $DIRECTORY/index.php << EOF
<!DOCTYPE html>
<html>
<head>
	<title>Verifikasi Domain Terinstall</title>
	<style>
		body {
			font-family: Arial, sans-serif;
			background-color: #f7f7f7;
			margin: 0;
			padding: 0;
		}
		.container {
			max-width: 800px;
			margin: 0 auto;
			padding: 20px;
		}
		h1 {
			text-align: center;
			color: #4CAF50;
		}
		p {
			font-size: 18px;
			line-height: 1.5;
			color: #333;
			margin-bottom: 20px;
		}
		.success {
			color: #4CAF50;
			font-weight: bold;
		}
		.failure {
			color: #F44336;
			font-weight: bold;
		}
	</style>
</head>
<body>
	<div class="container">
		<h1>Verifikasi Domain Terinstall</h1>
		<p>Selamat! Domain <span class="success">$DOMAIN</span> telah terinstall dengan sukses!</p>
		<?php
			if (function_exists('phpversion')) {
				echo '<p>Versi PHP yang terpasang adalah <span class="success">' . phpversion() . '</span>.</p>';
			} else {
				echo '<p class="failure">PHP tidak terpasang pada server ini.</p>';
			}

			if (function_exists('php_sapi_name') && (substr(php_sapi_name(), 0, 3) == 'fpm')) {
				echo '<p>Versi FPM yang aktif adalah <span class="success">' . php_sapi_name() . '</span>.</p>';
			} else {
				echo '<p class="failure">FPM tidak terpasang atau tidak aktif pada server ini.</p>';
			}
		?>
		<p>Anda sekarang dapat memulai untuk mengembangkan website Anda.</p>
		<p>Jangan ragu untuk menghubungi kami jika Anda memerlukan bantuan.</p>
		<p>Terima kasih telah memilih layanan kami.</p>
	</div>
</body>
</html>

EOF
    echo -e "\nPembuatan Direktori webiste files Sukses\n"
    sleep 1

    # Atur kepemilikan dan izin direktori
    chown -R www-data:www-data $DIRECTORY
    chmod -R 755 $DIRECTORY
    echo -e "\nMengatur kepemilikan dan izin direktori Sukses\n"
    sleep 1

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
    echo -e "\nPembuatan $DOMAIN.conf Sukses\n"
    sleep 1

    # Aktifkan Virtual Host Apache
    echo -e "\nMengaktifkan $DOMAIN.conf Apache\n"
    sleep 1
    a2ensite $DOMAIN.conf

    # Disable default Virtual Host Apache
    echo -e "\nDisable 000-default.conf\n"
    sleep 1
    a2dissite 000-default.conf
    
    # Uji konfigurasi Apache
    echo -e "\nUji konfigurasi Apache\n"
    sleep 1
    apache2ctl configtest
    
    # Restart Apache
    echo -e "\nRestart Apache\n"
    sleep 2
    systemctl restart apache2
    clear

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
    echo -e "\ncek certbot\n"
    sleep 1
    check_package "certbot" "install"
    echo -e "\ncek ufw\n"
    sleep 1
    check_package "ufw" "install"
    ufw enable

    ufw allow 80
    ufw allow 443
    ufw allow 22
    ufw allow 9090
    echo -e "\nSukses membuka Port 80,443,22,9090\n"
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