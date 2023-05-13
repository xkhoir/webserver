domain_setup () {
    read -p "Masukkan nama domain kamu :" DOMAIN
    clear
    
    # cek status layanan Apache
    APACHE2_STATUS="$(systemctl is-active apache2)"
    # cek status layanan Nginx
    NGINX_STATUS="$(systemctl is-active nginx)"
    #apache vhost dir
    APACHE2_VHOST_DIR="/etc/apache2/sites-available/$DOMAIN.conf"
    #nginx vhost dir
    NGINX_VHOST_DIR="/etc/nginx/sites-available/$DOMAIN"
    #Document root
    DIRECTORY="/var/www/$DOMAIN/public_html/"
    #apache log dir
    LOG="/var/log/apache2/$DOMAIN"


    # cek apakah layanan Apache aktif
    if [ "$APACHE2_STATUS" = "active" ]; then
        echo -e "\nApache sedang aktif"
        sleep 2
        # cek apakah domain di layanan Apache sudah adagi
        if [ -f "$APACHE2_VHOST_DIR" ]; then
            echo -e "\nDomain $DOMAIN sudah ada di vhost Apache. \ntidak perlu ditambahkan lagi.."
        else
            #code apache2
            if [[ "$1" == "cockpit" ]]; then

                #call fungsi addlog
                addlog
                
                #call fungsi manage_vhost
                manage_vhost "apache" "cockpit"

                # konfigurasi yang akan dimasukkan ke dalam file
                config="[WebService]\nOrigins = https://$DOMAIN http://$DOMAIN http://localhost:9090\nProtocolHeader = X-Forwarded-Proto\nAllowUnencrypted = true"

                # Buat file cockpit.conf
                touch /etc/cockpit/cockpit.conf

                # jalankan perintah echo untuk menambahkan konfigurasi ke dalam file
                echo -e "$config" >> /etc/cockpit/cockpit.conf

                # Aktifkan Virtual Host Apache
                echo -e "\nMengaktifkan $DOMAIN.conf Apache"
                sleep 1
                a2ensite $DOMAIN.conf
                
                # Aktifkan a2enmod untuk proxy
                echo -e "\nMengaktifkan $DOMAIN.conf Apache"
                sleep 1
                a2enmod proxy proxy_wstunnel proxy_http ssl rewrite

                # Disable default Virtual Host Apache
                echo -e "\nDisable 000-default.conf"
                sleep 1
                a2dissite 000-default.conf
                
                # Uji konfigurasi Apache
                echo -e "\nUji konfigurasi Apache"
                sleep 1
                apache2ctl configtest

                # Restart cockpit service
                echo -e "\nRestart Cockpit Service"
                sleep 2
                systemctl restart cockpit.service
                clear

                # Restart Apache
                echo -e "\nRestart Apache"
                sleep 2
                systemctl restart apache2
                clear

            elif [[ "$1" == "webserver" ]]; then
                check_php
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

                #mengganti kata "RDOMAIN" pada baris ke-56 dari file "index.php" dengan nilai dari variabel $DOMAIN.
                sed -i "s#RDOMAIN#$DOMAIN#g" $DIRECTORY/index.php
                #mengganti kata "RLOG" pada baris ke-78 dari file "index.php" dengan nilai dari variabel $LOG.
                sed -i "s#RLOG#$LOG#g" $DIRECTORY/index.php
                #mengganti kata "php-fpm7.4" pada baris ke-106 dari file "index.php" dengan nilai dari variabel $versi_terpilih.
                sed -i "s#php-fpm#$versi_terpilih#g" $DIRECTORY/index.php

                # Atur kepemilikan dan izin direktori
                chown -R www-data:www-data $DIRECTORY
                chmod -R 755 $DIRECTORY
                echo -e "\nMengatur kepemilikan dan izin direktori Sukses"
                sleep 1

                # call fungsi manage_vhost
                manage_vhost "apache" "webserver"

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

            else
            echo "Silakan tentukan [cockpit|webserver] sebagai argumen pertama."
            fi

            echo -e"\nApakah Anda ingin menginstal SSL untuk $DOMAIN? (y/n)"
            read INSTALL_SSL

            #ssl installer
            if [ "$INSTALL_SSL" == "y" ]; then
                # Peroleh sertifikat SSL
                ssl_setup "apache" "$DOMAIN"
            else
                echo -e "\nOK, anda masih tetap dapat menginstall SSL secara manual,"
                echo -e "\nAtau anda dapat menuju submenu apache no.4"
            fi
        fi
    # cek apakah layanan Nginx aktif
    elif [ "$NGINX_STATUS" = "active" ]; then
        echo -e "\nNginx sedang aktif"
        sleep 2
        # cek apakah domain di layanan Nginx sudah ada
        if [ -f "$NGINX_VHOST_DIR" ]; then
            echo -e "\nDomain $DOMAIN sudah ada di vhost Nginx. \ntidak perlu ditambahkan lagi.."
        else
            #code nginx
            if [[ "$1" == "cockpit" ]]; then
                manage_vhost "nginx" "cockpit"
            elif [[ "$1" == "webserver" ]]; then
                #call fungsi check_php
                check_php

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
                manage_vhost "nginx" "webserver"

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
            else
            echo "Silakan tentukan [cockpit|webserver] sebagai argumen pertama."
            fi
            #ssl installer
            if [ "$INSTALL_SSL" == "y" ]; then
                # Peroleh sertifikat SSL
                ssl_setup "nginx" "$DOMAIN"
            else
                echo -e "\nOK, anda masih tetap dapat menginstall SSL secara manual,"
                echo -e "\nAtau anda dapat menuju submenu apache no.4"
            fi
        fi
    else
        # Jika tidak terdapat Nginx atau Apache yang aktif, keluarkan pesan kesalahan
        echo -e"\nTidak ditemukan webserver di server ini. \ndiharap install dulu atau enable service\n"
        sleep 3
        clear
    fi

}

# Fungsi sslsetup untuk mengatur SSL pada server menggunakan Certbot
ssl_setup() {
    # Cek apakah Certbot sudah terinstal
    check_package "certbot" "install"
    check_package "ufw" "install"

    # Cek apakah UFW sudah diaktifkan atau belum
    ufw_status="$(sudo ufw status | awk '{print $2}')"
    if [[ "${ufw_status}" == "inactive" ]]; then
    echo "UFW belum diaktifkan, mengaktifkan UFW..."
    sudo ufw enable
    fi

    # Cek apakah port 22, 80, dan 443 sudah diizinkan atau belum
    allowed_ports="$(sudo ufw status | grep '22.*ALLOW\|9090.*ALLOW\|80.*ALLOW\|443.*ALLOW')"
    if [[ -z "${allowed_ports}" ]]; then
    echo "Port 22, 80, dan/atau 443 belum diizinkan, mengizinkan port..."
    sudo ufw allow 22
    sudo ufw allow 9090
    sudo ufw allow 80
    sudo ufw allow 443
    fi

    # Cek apakah argumen pertama adalah apache
    if [ "$1" == "apache" ]; then
        # Cek apakah python3-certbot-apache sudah terinstal
        check_package "python3-certbot-apache" "install"
        # Jika argumen kedua tidak kosong, jalankan Certbot dengan opsi --apache dan -d $2
        if [ -n "$2" ]; then
            sudo certbot --apache -d "$2"
        else
            # Jika argumen kedua kosong, jalankan Certbot dengan opsi --apache saja
            sudo certbot --apache
        fi
    # Cek apakah argumen pertama adalah nginx
    elif [ "$1" == "nginx" ]; then
        # Cek apakah python3-certbot-nginx sudah terinstal
        check_package "python3-certbot-nginx" "install"
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
check_php() {
    # Dapatkan daftar service PHP-FPM yang aktif
    active_services=$(systemctl list-units --type=service | grep "php.*-fpm.service" | grep "running" | awk '{print $1}')

    # Cek apakah tidak ada service PHP-FPM yang aktif
    if [ -z "$active_services" ]; then
    echo -e "\nTidak ada PHP-FPM yang aktif."
    exit 1
    fi

    # Buat array dari versi PHP-FPM yang aktif
    php_versions=()
    for service_name in $active_services; do
    version=$(echo $service_name | sed -e 's/php\(.*\)-fpm.service/\1/')
    php_versions+=("$version")
    done

    # Tampilkan menu
    echo -e "\nPilih versi PHP-FPM yang aktif:"

    # Loop melalui versi yang aktif dan tampilkan dengan nomor urutan
    for i in "${!php_versions[@]}"; do
        number=$((i+1))
        echo "$number. ${php_versions[$i]}"
    done

    # Prompt user untuk memilih versi
    read -p "Masukkan nomor versi PHP-FPM yang diinginkan: " version_number

    # Validasi input
    if ! [[ $version_number =~ ^[1-9][0-9]*$ ]] || (( version_number > ${#php_versions[@]} )); then
        clear
        echo "Input tidak valid."
        exit 1
    fi

    # Dapatkan versi yang dipilih
    versi_terpilih=${php_versions[$((version_number-1))]}

    # Gunakan versi PHP-FPM yang dipilih
    echo -e "\nMenggunakan PHP-FPM versi $versi_terpilih."
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

    echo -e "\nDirektori file log apache2 untuk $DOMAIN telah berhasil dibuat."
    sleep 2
}

# Fungsi untuk tambah file info.php
addinfo () {
    # fungsi untuk membuat file php untuk info
    echo -n "<?php phpinfo() ?>" | cat > $DIRECTORY/info.php
}

manage_vhost () {
  if [ "$1" = "apache" ]; then
    if [ "$2" = "cockpit" ]; then
        echo "Kode untuk mengonfigurasi virtual host Apache untuk Cockpit"
        APACHE_VHOST_COCKPIT
    elif [ "$2" = "webserver" ]; then
        echo "Kode untuk mengonfigurasi virtual host Apache untuk web server generik"
        APACHE_VHOST_WEBSERVER
    else
        echo "Silakan tentukan [cockpit|webserver] sebagai argumen kedua"
    fi
  elif [ "$1" = "nginx" ]; then
    if [ "$2" = "cockpit" ]; then
        echo "Kode untuk mengonfigurasi virtual host Apache untuk Cockpit"
        NGINX_VHOST_COCKPIT
    elif [ "$2" = "webserver" ]; then
        echo "Kode untuk mengonfigurasi virtual host Apache untuk web server generik"
        NGINX_VHOST_WEBSERVER
    else
        echo "Silakan tentukan [cockpit|webserver] sebagai argumen kedua"
    fi
  else
    echo "Silakan tentukan [nginx|apache] sebagai argumen pertama"
  fi
}

# manage_vhost "$@"

APACHE_VHOST_WEBSERVER () {
# Buat Virtual Host Apache WEBSERVER
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



</VirtualHost>" | cat > /etc/apache2/sites-available/$DOMAIN.conf

    # Tambah untuk conf fpm apache
    sudo sed -i '13s/.*/    <FilesMatch \\.php$>\n\tSetHandler "proxy:unix:\/run\/php\/'$versi_terpilih'.sock|fcgi:\/\/localhost\/"\n    <\/FilesMatch>/' /etc/apache2/sites-available/$DOMAIN.conf
    # Tambah untuk conf log apache
    sudo sed -i "/^<\/VirtualHost>/i \
    \    ErrorLog \${APACHE_LOG_DIR}\\/$DOMAIN\\/error.log\n\
    CustomLog \${APACHE_LOG_DIR}\\/$DOMAIN\\/access.log combined" /etc/apache2/sites-available/$DOMAIN.conf

    echo -e "\nFile vhost $DOMAIN.conf sukses dibuat"
    sleep 4
}

APACHE_VHOST_COCKPIT () {
# Buat Virtual Host Apache COCKPIT
echo -n "<VirtualHost *:80>
    ServerName $DOMAIN
</VirtualHost>" | cat > $APACHE2_VHOST_DIR

    # edit vhost 
    sed -i '/ServerName/a\\nProxyPreserveHost On\nProxyRequests Off\n\n# allow for upgrading to websockets\nRewriteEngine On\nRewriteCond %{HTTP:Upgrade} =websocket [NC]\nRewriteRule /(.*)           ws://localhost:9090/$1 [P,L]\nRewriteCond %{HTTP:Upgrade} !=websocket [NC]\nRewriteRule /(.*)           http://localhost:9090/$1 [P,L]\n\n# Proxy to your local cockpit instance\nProxyPass / http://localhost:9090/\nProxyPassReverse / http://localhost:9090/\n' $APACHE2_VHOST_DIR

    # Tambah untuk conf log apache
    sudo sed -i "/^<\/VirtualHost>/i \
    \    ErrorLog \${APACHE_LOG_DIR}\\/$DOMAIN\\/error.log\n\
    CustomLog \${APACHE_LOG_DIR}\\/$DOMAIN\\/access.log combined" $APACHE2_VHOST_DIR

    echo -e "\nFile vhost $DOMAIN.conf sukses dibuat"
    sleep 4
}

NGINX_VHOST_WEBSERVER () {
# Buat blok server Nginx WEBSERVER
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
        fastcgi_pass unix:/run/php/$VERSI_TERPILIH.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}" | cat > $NGINX_VHOST_DIR
}

NGINX_VHOST_COCKPIT () {
# Buat blok server Nginx COCKPIT
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
        fastcgi_pass unix:/run/php/$VERSI_TERPILIH.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}" | cat > $NGINX_VHOST_DIR
}