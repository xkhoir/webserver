#!/bin/bash

echo "Setup domain di Apache2"
sleep 2

read -p "Masukkan nama domain anda :" domain;

echo -e "\nProses pembuatan direktori $domain di /var/www\n"
sleep 2
echo -e "Masuk ke direktori /var/www\n"
cd /var/www
echo -n "Mengarahkan ke direktori : "pwd
sleep 2
echo -e "\nMembuat dan masuk ke direktori /var/www/$domain\n"
mkdir $domain
cd $domain
echo -n "Mengarahkan ke direktori : "pwd
sleep 2
echo -e "\nMembuat dan masuk ke folder /var/www/$domain/public_html\n"
mkdir public_html
cd public_html
echo -n "Mengarahkan ke direktori : "pwd

echo -e "\nMembuat file phpinfo pada index.php /var/www/$domain/public_html\n"
echo "
<html>
    <head>
        <title>Welcome to $domain!</title>
    </head>
    <body>
        <h1>Success!  The $domain virtual host is working!</h1>
    </body>
</html>
" | cat > index.html

echo "Folder /var/www/$domain telah dibuat"
sleep 2
#exit 0
pwd
cd ../../
sudo chmod -R 755 /var/www/$domain
sudo chown www-data:www-data /var/www/$domain/public_html

cd
clear
echo -e "\nKonfigurasi apache untuk $domain di /etc/apache2/sites-available\n"
sleep 2
echo -e "Masuk ke direktori /etc/apache2/sites-available\n"

cd /etc/apache2/sites-available
pwd
echo -e "Membuat file konfigurasi apache untuk $domain\n"
echo "
<VirtualHost *:80>
    ServerAdmin webmin@$domain
    ServerName $domain
    ServerAlias www.$domain
    DocumentRoot /var/www/$domain/public_html
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
" | cat > $domain.conf
clear
echo -e "Enable /etc/apache2/sites-available/$domain.conf\n"
sleep 2
sudo a2ensite $domain.conf
clear
echo -e "Disable /etc/apache2/sites-available/000-default.conf\n"
sleep 2
sudo a2dissite 000-default.conf
clear
echo -e "Restart service apache2\n"
sleep 2
sudo systemctl restart apache2

echo -e "Domain $domain sudah ready\n"
sleep 3

exit 0
