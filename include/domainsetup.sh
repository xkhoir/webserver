#!/bin/bash

# Memanggil fungsi bash dari file yang berbeda
source check_package.sh

# fungsi untuk menampilkan submenu Apache
domain_setup() {
    read -p "Masukkan nama domain kamu :" domain;

    echo -e "\nProses pembuatan direktori /var/www/$domain"
    sleep 2
    mkdir /var/www/$domain
    echo -e "\nProses pembuatan direktori /var/www/$domain/public_html"
    sleep 2
    mkdir /var/www/$domain/public_html
    
    echo -e "\nMembuat file cek pada index.php /var/www/$domain/public_html\n"
    sleep 2
    echo "
    <html>
        <head>
            <title>Welcome to $domain!</title>
        </head>
        <body>
            <h1>Success!  The $domain virtual host is working!</h1>
        </body>
    </html>
    " | cat > /var/www/$domain/public_html/index.html
    
    echo -e "\nProses perubahan permission ke 755 dan www-data\n"
    sudo chmod -R 755 /var/www/$domain
    sudo chown www-data:www-data /var/www/$domain/public_html
    
    echo -e "Membuat file konfigurasi VirtualHost apache untuk $domain\n"
echo "<VirtualHost *:80>
    ServerAdmin webmin@$domain
    ServerName $domain
    ServerAlias www.$domain
    DocumentRoot /var/www/$domain/public_html
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
    </VirtualHost>" | cat > /etc/apache2/sites-available/$domain.conf
    
    clear
    echo -e "Enable /etc/apache2/sites-available/$domain.conf\n"
    sleep 2
    a2ensite $domain.conf
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
	echo -e ""
	# sudo add-apt-repository ppa:certbot/certbot
	# sudo apt update
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
    echo -e "\nSSL Let's Encrypt selesai silahkah akses https://domain-anda\n"
    sleep 3
    exit 0
}

ssl_renew() {
    echo -e "\nRenew SSL Process\n"
    sleep 2
    #SSL renewal process
    certbot renew --dry-run
}