domain_setup () {
    read -p "Masukkan nama domain kamu :" DOMAIN
    clear
    
    # cek status layanan Apache
    APACHE2_STATUS="$(systemctl is-active apache2)"
    # cek status layanan Nginx
    NGINX_STATUS="$(systemctl is-active nginx)"
    # cek status layanan Caddy
    CADDY_STATUS="$(systemctl is-active caddy)"
    #apache vhost dir
    APACHE2_VHOST_DIR="/etc/apache2/sites-available/$DOMAIN.conf"
    #nginx block dir
    NGINX_VHOST_DIR="/etc/nginx/sites-available/$DOMAIN"
    #caddy block dir
    CADDY_VHOST_DIR="/etc/caddy/Caddyfile"
    #Document root
    DIRECTORY="/var/www/$DOMAIN/public_html/"
    #Document root
    BACDIRECTORY="/var/www/$DOMAIN/backup/"
    #apache log dir
    APACHELOG="/var/log/apache2/$DOMAIN"

    # cek apakah layanan Apache aktif
    if [ "$APACHE2_STATUS" = "active" ]; then
        echo -e "\nApache sedang aktif"
        sleep 2
        # cek apakah domain di layanan Apache sudah adagi
        if [ -f "$APACHE2_VHOST_DIR" ]; then
            echo -e "\nDomain $DOMAIN sudah ada di vhost Apache. \ntidak perlu ditambahkan lagi.."
        else
            #code apache2
            if [[ "$1" == "adddomain" ]]; then
                #call fungsi check_php
                check_php
                #call fungsi add_fpm_pool
                add_fpm_pool
                #call fungsi add_docroot
                add_docroot
                #call fungsi add_apache_log
                add_apache_log
                #call fungsi add_info
                add_info
                #call fungsi add_index
                add_index
                #call fungsi add_apache_vhost
                add_apache_vhost
                #call fungsi add_change_docroot_owner
                change_docroot_owner
            elif [[ "$1" == "addproxydomain" ]]; then
                #call fungsi add_apache_log
                add_apache_log
                #call fungsi delete_apache_vhost
                add_apache_proxy_vhost
            elif [[ "$1" == "deletedomain" ]]; then
                #call fungsi delete_apache_vhost
                delete_apache_vhost
            else
                echo "Silakan tentukan [adddomain|addproxydomain|deletedomain] sebagai argumen pertama."
            fi
            #call dungsi reqsslapache
            req_apache_ssl
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
            if [[ "$1" == "adddomain" ]]; then
                #call fungsi check_php
                check_php
                #call fungsi add_fpm_pool
                add_fpm_pool
                #call fungsi add_docroot
                add_docroot
                #call fungsi add_info
                add_info
                #call fungsi add_index
                add_index
                #call fungsi add_nginx_blok
                add_nginx_blok
                #call fungsi add_change_docroot_owner
                change_docroot_owner
            elif [[ "$1" == "addproxydomain" ]]; then
                add_nginx_proxy_blok
            elif [[ "$1" == "deletedomain" ]]; then
                delete_nginx_blok
            else
                echo "Silakan tentukan [adddomain|addproxydomain|deletedomain] sebagai argumen pertama."
            fi
            req_nginx_ssl
        fi
    # cek apakah layanan Caddy aktif
    elif [ "$CADDY_STATUS" = "active" ]; then
        echo -e "\nCaddy sedang aktif"
        sleep 2
        #code caddy
        if [[ "$1" == "adddomain" ]]; then
            #call fungsi check_php
            check_php
            #call fungsi add_fpm_pool
            add_fpm_pool
            #call fungsi add_docroot
            add_docroot
            #call fungsi add_info
            add_info
            #call fungsi add_index
            add_index
            #call fungsi add_caddy_blok
            add_caddy_blok
            #call fungsi add_change_docroot_owner
            change_docroot_owner      
        elif [[ "$1" == "addproxydomain" ]]; then
            add_caddy_proxy_blok
        elif [[ "$1" == "deletedomain" ]]; then
            delete_caddy_blok
        else
            echo "Silakan tentukan [adddomain|addproxydomain|deletedomain] sebagai argumen pertama."
        fi
        echo "caddy sudah auto sll"
    else
        # Jika tidak terdapat Nginx atau Apache yang aktif, keluarkan pesan kesalahan
        echo -e "\nTidak ditemukan webserver di server ini. \ndiharap install dulu atau enable service\n"
        sleep 3
        clear
    fi
}

# Fungsi untuk tambah file info.php
add_info () {
    # fungsi untuk membuat file php untuk info
    echo -n "<?php phpinfo() ?>" | cat > $BACDIRECTORY/info.php
}

# Fungsi untuk tambah file info.php
add_index () {
    #Menyalin file "index.php" ke direktori yang ditentukan dalam variabel $DIRECTORY.
    cp index.php $BACDIRECTORY
    #mengganti kata "RDOMAIN" pada baris ke-56 dari file "index.php" dengan nilai dari variabel $DOMAIN.
    sed -i "s#RDOMAIN#$DOMAIN#g" $BACDIRECTORY/index.php
    #mengganti kata "RLOG" pada baris ke-78 dari file "index.php" dengan nilai dari variabel $LOG.
    sed -i "s#RLOG#$APACHELOG#g" $BACDIRECTORY/index.php
    #mengganti kata "php-fpm7.4" pada baris ke-106 dari file "index.php" dengan nilai dari variabel $versi_terpilih.
    sed -i "s#php-fpm#$versi_terpilih#g" $BACDIRECTORY/index.php
}

add_docroot () {
    # Buat direktori public_html untuk website files
    mkdir -p $DIRECTORY
    # Buat direktori backup
    mkdir -p $BACDIRECTORY
    echo -e "\nPembuatan Direktori webiste files Sukses"
    sleep 1
}

change_docroot_owner () {
    # Atur kepemilikan dan izin direktori
    chown -R www-data:www-data $DIRECTORY
    chmod -R 755 $DIRECTORY
    echo -e "\nMengatur kepemilikan dan izin direktori Sukses"
    sleep 1
}

add_cockpit_conf () {
    # konfigurasi yang akan dimasukkan ke dalam file
    config="[WebService]\nOrigins = https://$DOMAIN http://$DOMAIN http://localhost:9090\nProtocolHeader = X-Forwarded-Proto\nAllowUnencrypted = true"
    # Buat file cockpit.conf
    touch /etc/cockpit/cockpit.conf
    # jalankan perintah echo untuk menambahkan konfigurasi ke dalam file
    echo -e "$config" >> /etc/cockpit/cockpit.conf
}

#apache===================
add_apache_vhost () {
    # Membuat konfigurasi virtual host
    echo -e "<VirtualHost *:80>\n\tServerAdmin webmin@$DOMAIN\n\tServerName $DOMAIN\n\n\tDocumentRoot /var/www/$DOMAIN/public_html\n\n\t<FilesMatch \\.php\$>\n\t\tSetHandler \"proxy:unix:/var/run/php/$DOMAIN.sock|fcgi://localhost/\"\n\t</FilesMatch>\n\n\tErrorLog \${APACHE_LOG_DIR}/$DOMAIN/error.log\n\tCustomLog \${APACHE_LOG_DIR}/$DOMAIN/access.log combined\n\n\t<Directory /var/www/$DOMAIN/public_html>\n\t\tOptions FollowSymLinks\n\t\tAllowOverride All\n\t\tRequire all granted\n\t</Directory>\n</VirtualHost>" | sudo tee "$APACHE2_VHOST_DIR" > /dev/null
    echo "Vhost telah dibuat dengan konfigurasi untuk $DOMAIN"

    # Aktifkan Virtual Host Apache
    echo -e "\nMengaktifkan vhost $DOMAIN.conf"
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
}

add_apache_proxy_vhost () {
    # Meminta input domain dari pengguna
    read -p "Masukkan domain/ip tujuan (default: localhost): " destination
    # Jika variabel destination kosong, maka atur nilai default ke "localhost"
    destination=${destination:-localhost}
    read -p "Masukkan port tujuan: " port

    # Membuat konfigurasi virtual host dengan proxy
    echo -e "<VirtualHost *:80>\n\tServerName $DOMAIN\n\tProxyPass / http://$destination:$port/\n\tProxyPassReverse / http://$destination:$port/\n\n\tErrorLog \${APACHE_LOG_DIR}/$DOMAIN/error.log\n\tCustomLog \${APACHE_LOG_DIR}/$DOMAIN/access.log combined\n</VirtualHost>" | sudo tee "$APACHE2_VHOST_DIR" > /dev/null
    echo -e "\nVhost telah dibuat dengan konfigurasi proxy untuk $DOMAIN ke $destination:$port"
    sleep 1

    # Aktifkan Virtual Host Apache
    echo -e "\nMengaktifkan vhost $DOMAIN.conf"
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
    
    # Aktifkan a2enmod untuk proxy
    echo -e "\nMengaktifkan $DOMAIN.conf Apache"
    sleep 1
    a2enmod proxy proxy_wstunnel proxy_http ssl rewrite
    
    # Restart Apache
    echo -e "\nRestart Apache"
    sleep 2
    systemctl restart apache2
    clear
}

delete_apache_vhost () {
    # Menonaktifkan Virtual Host Apache
    a2dissite $DOMAIN.conf
    systemctl restart apache2
    echo -e "\nMenonaktifkan vhost $DOMAIN.conf"
    sleep 1
    
    read -p "Apakah Anda ingin menghapus vhost dari $DOMAIN? (y/t): " confirm
    if [ "$confirm" == "y" ]; then
        rm -rf $APACHE2_VHOST_DIR
        echo "Direktori $APACHE2_VHOST_DIR telah dihapus."
        sleep 1
    else
        echo "direktori $APACHE2_VHOST_DIR Tidak dihapus"
        sleep 1
    fi
    
    read -p "Apakah Anda ingin menghapus docroot dari $DOMAIN? (y/t): " confirm1
    if [ "$confirm1" == "y" ]; then
        rm -rf /var/www/$DOMAIN
        echo "Direktori /var/www/$DOMAIN telah dihapus."
        sleep 1
    else
        echo "direktori /var/www/$DOMAIN Tidak dihapus"
        sleep 1
    fi
}

# Fungsi untuk tambah file log
add_apache_log () {
    # Membuat direktori log untuk domain
    sudo mkdir -p $APACHELOG

    # Membuat file access.log dan error/log
    sudo touch $APACHELOG/access.log
    sudo touch $APACHELOG/error.log

    # Mengubah kepemilikan dan izin direktori log
    sudo chown -R www-data:www-data $APACHELOG
    sudo chmod -R 775 $APACHELOG

    echo -e "\nDirektori file log apache2 untuk $DOMAIN telah berhasil dibuat."
    sleep 2
}

req_apache_ssl () {
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
}

#nginx====================
add_nginx_blok () {
    # Membuat konfigurasi Server Blok
    echo -e "server {\n\tlisten 80;\n\tserver_name $DOMAIN;\n\n\tlocation / {\n\t\troot /var/www/$DOMAIN/public_html;\n\t\tindex index.html index.htm index.php;\n\t}\n\n\tlocation ~ \.php$ {\n\t\tinclude snippets/fastcgi-php.conf;\n\t\tfastcgi_pass unix:/var/run/php/$DOMAIN.sock;\n\t}\n\n\terror_log /var/log/nginx/$DOMAIN.error;\n\taccess_log /var/log/nginx/$DOMAIN.access;\n}" | sudo tee "$NGINX_VHOST_DIR" > /dev/null
    echo "Server Blok telah dibuat dengan konfigurasi untuk $DOMAIN"

    # Aktifkan Server Blok Nginx
    echo -e "\nMengaktifkan Server Blok $DOMAIN"
    sleep 1
    sudo ln -s "$NGINX_VHOST_DIR" "/etc/nginx/sites-enabled/"
    
    # Uji konfigurasi Nginx
    echo -e "\nUji konfigurasi Nginx"
    sleep 1
    sudo nginx -t
    
    # Restart Nginx
    echo -e "\nRestart Nginx"
    sleep 2
    sudo systemctl restart nginx
    clear
}

add_nginx_proxy_blok () {
    # Meminta input domain dari pengguna
    read -p "Masukkan domain/ip tujuan (default: localhost): " destination
    # Jika variabel destination kosong, maka atur nilai default ke "localhost"
    destination=${destination:-localhost}
    read -p "Masukkan port tujuan: " port

    # Membuat konfigurasi server blok dengan proxy
    echo -e "server {\n\tlisten 80;\n\tserver_name $DOMAIN;\n\n\tlocation / {\n\t\tproxy_pass http://$destination:$port;\n\t\tproxy_set_header Host \$host;\n\t\tproxy_set_header X-Real-IP \$remote_addr;\n\t}\n\n\terror_log /var/log/nginx/$DOMAIN.error;\n\taccess_log /var/log/nginx/$DOMAIN.access;\n}" | sudo tee "$NGINX_VHOST_DIR" > /dev/null
    echo -e "\nServer Blok telah dibuat dengan konfigurasi proxy untuk $DOMAIN ke $destination:$port"
    sleep 1

    # Aktifkan Server Blok Nginx
    echo -e "\nMengaktifkan Server Blok $DOMAIN"
    sleep 1
    sudo ln -s "$NGINX_VHOST_DIR" "/etc/nginx/sites-enabled/"
    
    # Uji konfigurasi Nginx
    echo -e "\nUji konfigurasi Nginx"
    sleep 1
    sudo nginx -t
    
    # Restart Nginx
    echo -e "\nRestart Nginx"
    sleep 2
    sudo systemctl restart nginx
    clear
}

delete_nginx_blok () {
    # Menonaktifkan Server blok Nginx
    sudo rm -f "/etc/nginx/sites-enabled/$DOMAIN"
    sudo rm -f "$NGINX_VHOST_DIR"
    sudo nginx -t
    sudo systemctl restart nginx
    echo -e "\nMenonaktifkan server blok $DOMAIN"
    sleep 1
    
    read -p "Apakah Anda ingin menghapus server blok dari $DOMAIN? (y/t): " confirm
    if [ "$confirm" == "y" ]; then
        echo "Direktori $NGINX_VHOST_DIR telah dihapus."
        sleep 1
    else
        echo "Direktori $NGINX_VHOST_DIR Tidak dihapus"
        sleep 1
    fi
    
    read -p "Apakah Anda ingin menghapus docroot dari $DOMAIN? (y/t): " confirm1
    if [ "$confirm1" == "y" ]; then
        rm -rf /var/www/$DOMAIN
        echo "Direktori /var/www/$DOMAIN telah dihapus."
        sleep 1
    else
        echo "Direktori /var/www/$DOMAIN Tidak dihapus"
        sleep 1
    fi
}


req_nginx_ssl () {
    echo -e"\nApakah Anda ingin menginstal SSL untuk $DOMAIN? (y/n)"
    read INSTALL_SSL

    #ssl installer
    if [ "$INSTALL_SSL" == "y" ]; then
    # Peroleh sertifikat SSL
        ssl_setup "nginx" "$DOMAIN"
    else
        echo -e "\nOK, anda masih tetap dapat menginstall SSL secara manual,"
        echo -e "\nAtau anda dapat menuju submenu apache no.4"
    fi
}

#caddy====================
add_caddy_blok () {
    # Cek apakah domain sudah ada dalam Caddyfile
    if grep -q "$DOMAIN" "$CADDY_VHOST_DIR"; then
        echo "Domain $DOMAIN sudah ada dalam Caddyfile."
        sleep 2
    else
        # Cari baris terakhir dalam Caddyfile
        last_line=$(grep -nE "^}" "$CADDY_VHOST_DIR" | tail -n 1 | cut -d ":" -f 1)
        # Cek apakah isi Caddyfile kosong
        if [ -z "$last_line" ]; then
            echo -e "\nIsi Caddyfile Kosong, Menambahkan blok konfigurasi baru..."
            sleep 2
            echo -e "$DOMAIN{\n\troot * $DIRECTORY\n\tencode gzip\n\tphp_fastcgi unix//run/php/$DOMAIN.sock\n\tfile_server\n}" > "$CADDY_VHOST_DIR"
            echo -e "\nCaddyfile telah diisi dengan konfigurasi untuk $DOMAIN"
            sleep 2
        else
            # Menambahkan blok konfigurasi setelah baris terakhir
            echo -e "\nIsi Caddyfile sudah ada, Menambahkan blok konfigurasi di baris baru..."
            sed -i "${last_line}a\\ \n$DOMAIN{\n\troot * $DIRECTORY\n\tencode gzip\n\tphp_fastcgi unix//run/php/$DOMAIN.sock\n\tfile_server\n}" "$CADDY_VHOST_DIR"
            echo -e "\nCaddyfile telah diisi dengan konfigurasi untuk $DOMAIN"
            sleep 2
        fi
    fi
}

add_caddy_proxy_blok () {
    # Cek apakah domain sudah ada dalam Caddyfile
    if grep -q "$DOMAIN" "$CADDY_VHOST_DIR"; then
        echo "Domain $DOMAIN sudah ada dalam Caddyfile."
        sleep 2
    else
        # Cari baris terakhir dalam Caddyfile
        last_line=$(grep -nE "^}" "$CADDY_VHOST_DIR" | tail -n 1 | cut -d ":" -f 1)
        read -p "Masukkan domain/ip tujuan (default: localhost): " destination
        # Jika variabel destination kosong, maka atur nilai default ke "localhost"
        destination=${destination:-localhost}
        read -p "Masukkan port tujuan: " port
        # Cek apakah isi Caddyfile kosong
        if [ -z "$last_line" ]; then
            echo -e "\nIsi Caddyfile Kosong, Menambahkan blok konfigurasi baru..."
            sleep 2
            echo -e "$DOMAIN{\n\treverse_proxy $destination:$port\n}" > "$CADDY_VHOST_DIR"
            echo -e "\nCaddyfile telah diisi dengan konfigurasi proxy untuk $DOMAIN ke $destination:$port"
            sleep 2
        else
            # Menambahkan blok konfigurasi setelah baris terakhir
            echo -e "\nIsi Caddyfile sudah ada, Menambahkan blok konfigurasi di baris baru..."
            sed -i "${last_line}a\\ \n$DOMAIN{\n\treverse_proxy $destination:$port\n}" "$CADDY_VHOST_DIR"
            echo -e "\nCaddyfile telah diisi dengan konfigurasi proxy untuk $DOMAIN ke $destination:$port"
            sleep 2
        fi
    fi
}

delete_caddy_blok () {
    # Cek apakah domain sudah ada dalam Caddyfile
    if grep ! -q "$DOMAIN" "$CADDY_VHOST_DIR"; then
        echo -e "\nDomain $DOMAIN sudah tidak ada dalam Caddyfile."
        sleep 2
    else 
        # Cari baris terakhir dalam Caddyfile
        last_line=$(grep -nE "^}" "$CADDY_VHOST_DIR" | tail -n 1 | cut -d ":" -f 1)
        # Cek apakah Caddyfile kosong
        if [ -z "$last_line" ]; then
            echo -e "\nKonfigurasi Caddyfile sudah kosong"
            sleep 2
        else
            # Hapus konfigurasi domain dari Caddyfile
            sed -i "/$DOMAIN{/,/}/d" "$CADDY_VHOST_DIR"
            echo -e "\nKonfigurasi untuk $DOMAIN telah dihapus dari Caddyfile"
            sleep 2
        fi
    fi
}

#php======================
# Fungsi untuk mengecek apakah PHP-FPM telah terpasang dan mengembalikan versi yang terpasang
check_php() {
    # Dapatkan daftar service PHP-FPM yang aktif
    #active_services=$(systemctl list-units --type=service | grep "php.*-fpm.service" | grep "running" | awk '{print $1}' | sed 's/\.service$//')
    active_services=$(systemctl list-units --type=service | grep "php.*-fpm.service" | grep "running" | awk '{print $1}' | sed 's/\.service$//' | sed 's/php//' | sed 's/-fpm//')

    # Cek apakah tidak ada service PHP-FPM yang aktif
    if [ -z "$active_services" ]; then
    echo -e "\nTidak ada PHP-FPM yang aktif."
    exit 1
    fi

    # Buat array dari versi PHP-FPM yang aktif
    php_versions=()
    for service_name in $active_services; do
    version=$(echo $service_name )
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

add_fpm_pool () {
    echo -e "[$DOMAIN]\nuser = www-data\ngroup = www-data\nlisten = /run/php/$DOMAIN.sock\nlisten.owner = www-data\nlisten.group = www-data\nlisten.mode = 0660\npm = dynamic\npm.max_children = 5\npm.start_servers = 2\npm.min_spare_servers = 1\npm.max_spare_servers = 3\nrequest_terminate_timeout = 300" | tee /etc/php/$versi_terpilih/fpm/pool.d/$DOMAIN.conf > /dev/null
    echo -e "\npembuatan pool berhasil"
    sleep 3
}

#ssl======================
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
