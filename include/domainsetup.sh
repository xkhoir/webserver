#!/bin/bash

# fungsi untuk menampilkan submenu Apache
domain_setup() {
    read -p "Masukkan nama domain kamu :" domain;

    clear
    mkdir /var/www/$domain
    echo -e "\nPembuatan direktori /var/www/$domain Sukses"
    sleep 2

    mkdir /var/www/$domain/public_html
    echo -e "\nPembuatan direktori /var/www/$domain/public_html Sukses"
    sleep 2
    
    mkdir /var/log/apache2/$domain
    echo -e "\nPembuatan direktori log /var/log/apache2/$domain Sukses"
    sleep 2

    echo "<!DOCTYPE html>
    <html>
    <head>
    <title>Welcome to $domain!</title>
    </head>
    <body>
        <center>
            <h1 style="color:green">Success !</h1>
            <p>The $domain virtual host is working!</p>
        </center>
    </body>
    </html>" | cat > /var/www/$domain/public_html/index.html
    echo -e "\nPembuatan file index.php /var/www/$domain/public_html Sukses"
    sleep 2

    echo -e "\nProses perubahan permission ke 755 dan www-data"
    sudo chmod -R 755 /var/www/$domain
    sudo chown www-data:www-data /var/www/$domain/public_html

    echo -e "/etc/apache2/sites-available/$domain.conf\n"
    echo "<VirtualHost *:80>
    ServerAdmin webmin@$domain
    ServerName $domain
    ServerAlias www.$domain
    DocumentRoot /var/www/$domain/public_html

    <Directory /var/www/$domain/public_html>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Order allow,deny
        allow from all
    </Directory>

    <FilesMatch \.php$>
        SetHandler 'proxy:unix:/run/php/php8.1-fpm.sock|fcgi://localhost/'
    </FilesMatch>

    ErrorLog \${APACHE_LOG_DIR}/$domain/error.log
    CustomLog \${APACHE_LOG_DIR}/$domain/access.log combined
    </VirtualHost>" | cat > /etc/apache2/sites-available/$domain.conf
    echo -e "\nPembuatan file konfigurasi VirtualHost Apache2 sukses"
    
    clear
    a2ensite $domain.conf
    echo -e "Enable /etc/apache2/sites-available/$domain.conf\n"
    sleep 2
    clear
    echo -e "Disable /etc/apache2/sites-available/000-default.conf\n"
    sleep 2
    a2dissite 000-default.conf
    clear
    echo -e "Restart service apache2\n"
    sleep 2
    systemctl reload apache2
    systemctl restart apache2
    echo -e "Direktori /var/www/$domain/public_html sudah ready\n"
    sleep 3

    clear
    echo "Apakah Anda ingin menginstal SSL untuk $domain? (y/n)"
    read install_ssl

    if [ "$install_ssl" == "y" ]; then
        # Baris kode untuk instalasi SSL
        ssl_setup
    else
        echo -e "\nOK, anda masih tetap dapat menginstall SSL secara manual,\n"
        echo -e "Atau anda dapat menuju submenu apache no.4\n"
    fi
    exit 0
}

# fungsi untuk menampilkan submenu Apache
ssl_setup() {
    #Memasang Let's Encrypt pada domain dengan certbot
    if ! dpkg -s certbot ufw >/dev/null 2>&1; then
        # install packages
        clear
        check_package "python3-certbot-apache" "install"
        clear
        check_package "ufw" "install"
        clear
        ufw enable
        ufw allow 22
    fi
        # continue with your next command here
        
        #install Let's Encrypt SSL
        clear
        certbot --apache
        echo -e "\nSSL Let's Encrypt selesai silahkan akses https://domain-anda\n"
        sleep 3
        exit 0
}

ssl_renew() {
    echo -e "\nRenew SSL Process\n"
    sleep 2
    #SSL renewal process
    certbot renew --dry-run
}