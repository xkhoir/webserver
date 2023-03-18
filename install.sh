#!/bin/bash

lagi='y'
while  [ $lagi == 'y' ] || [ $lagi == 'Y' ];
do
   clear
   echo "         Lamp Stack Server Auto Installer by         ";
   figlet xkhoirtech
   echo "=====================================================";
   echo -n "    Waktu system    : "; date
   echo -n "    Status pengguna : "; whoami
   echo -n "    Banyak user     : "; who | wc -l
   echo "=====================================================";
   echo "  -------------------- Menu List --------------------";
   echo "1. Update & Upgrade APT";
   echo "2. Install Apache2   ";
   echo "3. Install Mariadb   ";
   echo "4. Install PHP       ";
   echo "5. Auto Install All Lamp Stack Server";
   echo "  --------------------- Optional --------------------";
   echo "6. Install PhpMyAdmin";
   echo "7. Install Composer";
   echo "8. Setup a2enmod rewrite";
   echo "9. Change www folder Permissions 755";
   echo "10. Restart Apache2 Services";
   echo "11. Exit              ";
   read -p "Pilihan anda [1-11] :" pil;
if [ $pil -eq 1 ];
then
   clear
   echo -e "\n\nMengupdate & Upgrade Paket APT Terbaru\n"
   sleep 5
   sudo apt-get update -y
   sudo apt-get upgrade -y
   value="Update & Upgrade APT";
elif [ $pil -eq 2 ];
then
   clear
   echo -e "\n\nMenginstal Apache2 Web Server\n"
   sleep 5
   sudo apt-get install apache2 apache2-{doc,utils} libexpat1 ssl-cert -y
   clear

   echo -e "\n\nAllow Port 80 & 443\n"
   sleep 5
   ufw allow 80
   ufw allow 443
   value="Apache2";
elif [ $pil -eq 3 ];
then
   clear
   echo -e "\n\nMenginstal Mariadb Server\n"
   sleep 5
   sudo apt install mariadb-server -y
   clear
   echo -e "\n\nSetup Mariadb Server\n"
   sleep 5
   mysql_secure_installation
   value="Database Mariadb";
elif [ $pil -eq 4 ];
then
   clear
   echo -e "\n\nMenginstal PHP dan Extention penting\n"
   sleep 5
   sudo apt install php8.1 -y
   sudo apt install libapache2-mod-php8.1 -y
   sudo apt install php8.1-{bz2,cli,intl,common,mysql,zip,curl,gd,mbstring,xml,bcmath,phpdbg,cgi} -y
   value="PHP";
elif [ $pil -eq 5 ];
then
   clear
   echo -e "\n\nMengupdate & Upgrade Paket APT Terbaru\n"
   sleep 5
   sudo apt update -y
   sudo apt upgrade -y
   
   clear
   echo -e "\n\nMenginstal Apache2 Web Server\n"
   sleep 5
   sudo apt install apache2 apache2-{doc,utils} libexpat1 ssl-cert -y
   clear

   echo -e "\n\nAllow Port 80 & 443\n"
   sleep 5
   ufw allow 80
   ufw allow 443

   clear
   echo -e "\n\nMenginstal PHP dan Extention penting\n"
   sleep 5
   sudo apt install php8.1 -y
   sudo apt install libapache2-mod-php8.1 -y
   sudo apt install php8.1-{bz2,cli,intl,common,mysql,zip,curl,gd,mbstring,xml,bcmath,phpdbg,cgi} -y

   clear
   echo -e "\n\nMenginstal Mariadb Server\n"
   sleep 5
   sudo apt install mariadb-server -y
   clear

   echo -e "\n\nSetup Mariadb Server\n"
   sleep 5
   mysql_secure_installation

   clear
   echo -e "\n\nMenginstal PhpMyAdmin\n"
   sleep 5
   sudo apt install phpmyadmin -y

   value="Lamp Stack";
elif [ $pil -eq 6 ];
then
   clear
   echo -e "\n\nMenginstal PhpMyAdmin\n"
   sleep 5
   sudo apt install phpmyadmin -y
   value="PhpMyAdmin";
elif [ $pil -eq 7 ];
then
   clear
   echo -e "\n\nMenginstal Composer\n"
   sleep 5
   php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
   php -r "if (hash_file('sha384', 'composer-setup.php') === '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
   php composer-setup.php
   php -r "unlink('composer-setup.php');"
   clear
   echo -e "\n\nSet Composer to Globally\n"
   sleep 5
   sudo mv composer.phar /usr/bin/composer
   value="Composer";
elif [ $pil -eq 8 ];
then
   clear
   echo -e "\n\nEnabling Modules\n"
   sleep 5
   sudo a2enmod rewrite
   sudo phpenmod mcrypt
   value="a2enmod";
elif [ $pil -eq 9 ];
then
   clear
   echo -e "\n\nPermissions for /var/www\n"
   sleep 5
   sudo chown -R www-data:www-data /var/www
   echo -e "\n\n Permissions have been set\n"
   value="www-data Permissions";
elif [ $pil -eq 10 ];
then
   clear
   echo -e "\n\nRestarting Apache\n"
   sleep 3
   sudo service apache2 restart
   value="Restart Apache2";
elif [ $pil -eq 11 ];
then
   clear
   echo -e "\n\nTerima Kasih Telah Menggunakan script ini...\n"
   exit 0
else
   clear
   echo -e "\n\nSorry, Menu tidak tersedia\n"
   exit 1
fi
echo -e "\nInstalasi $value Berhasil"
echo
echo -n "Pilih lagi ? (y/t) :";
read lagi;
    #untuk validasi input
    while  [ $lagi != 'y' ] && [ $lagi != 'Y' ] && [ $lagi != 't' ] && [ $lagi != 'T' ];
    do
       echo -e "\n\nOps salah, isi lagi dengan (y/Y/t/Y)\n";
       echo -n "Pilih Sekali Lagi ? (y/t) :";
       read lagi;
    done
    echo -e "\n\nTerima Kasih Telah Menggunakan script ini...\n"
done