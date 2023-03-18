#!/bin/bash

lagi='y'
while  [ $lagi == 'y' ] || [ $lagi == 'Y' ];
do
   clear
   echo "        Lamp Stack Server Auto Uninstaller by        ";
      figlet xkhoirtech
   echo "=====================================================";
   echo -n "    Waktu system    : "; date
   echo -n "    Status pengguna : "; whoami
   echo -n "    Banyak user     : "; who | wc -l
   echo "=====================================================";
   echo "  -------------------- Menu List --------------------";
   echo "1. Update & Upgrade APT";
   echo "2. Uninstall Apache2   ";
   echo "3. Uninstall Mariadb   ";
   echo "4. Uninstall PHP       ";
   echo "5. Auto Uninstall All Lamp Stack Server";
   echo "  --------------------- Optional --------------------";
   echo "6. Uninstall PhpMyAdmin";
   echo "7. Uninstall Composer";
   echo "8. Return permissions for /var/www to root";
   echo "9. Exit              ";
   read -p "Pilihan anda [1-9] :" pil;
if [ $pil -eq 1 ];
then
   clear
   echo -e "\n\nMengupdate & Upgrade Paket APT Terbaru\n"
   sleep 2
   sudo apt-get update -y
   sudo apt-get upgrade -y
   value="Update & Upgrade APT";
elif [ $pil -eq 2 ];
then
   clear
   echo -e "\n\nUninstalling Apache2 Webserver\n" sleep 2
   sudo apt-get remove --purge apache2* -y
   
   clear
   echo -e "\n\nRunning Autoremove\n"
   sleep 2
   sudo apt autoremove -y
   sudo apt clean
   value="Apache2";
elif [ $pil -eq 3 ];
then
   clear
   echo -e "\n\nUninstalling Mariadb\n"
   sleep 2
   sudo apt-get remove --purge mariadb* -y
   
   clear
   echo -e "\n\nRunning Autoremove\n"
   sleep 2
   sudo apt autoremove -y
   sudo apt clean
   clear
   value="Database Mariadb";
elif [ $pil -eq 4 ];
then
   clear
   echo -e "\n\nUninstalling PHP\n"
   sleep 2
   sudo apt-get remove --purge php8.* -y
   
   clear
   echo -e "\n\nRunning Autoremove\n"
   sleep 2
   sudo apt autoremove -y
   sudo apt clean
   value="PHP";
elif [ $pil -eq 5 ];
then
   clear
   echo -e "\n\nMengupdate & Upgrade Paket APT Terbaru\n"
   sleep 2
   sudo apt update -y
   sudo apt upgrade -y
   
   clear
   echo -e "\n\nUninstalling Apache2 Web Server\n"
   sleep 2
   sudo apt-get remove --purge apache2* -y

   clear
   echo -e "\n\nUninstalling PhpMyAdmin\n"
   sleep 2
   sudo apt-get remove --purge phpmy* -y
   
   clear
   echo -e "\n\nUninstalling PHP dan Extention penting\n"
   sleep 2
   sudo apt-get remove --purge php8.* -y

   clear
   echo -e "\n\nUninstalling Mariadb\n"
   sleep 2
   sudo apt-get remove --purge mariadb* -y
   
   clear
   echo -e "\n\nRunning Autoremove\n"
   sleep 2
   sudo apt autoremove -y
   sudo apt clean
   
   value="Lamp Stack";
elif [ $pil -eq 6 ];
then
   clear
   echo -e "\n\nUninstalling PhpMyAdmin\n"
   sleep 2
   sudo apt-get remove --purge phpmy* -y
   
   clear
   echo -e "\n\nRunning Autoremove\n"
   sleep 2
   sudo apt autoremove -y
   sudo apt clean
   value="PhpMyAdmin";
elif [ $pil -eq 7 ];
then
   clear
   echo -e "\n\nUninstalling Composer\n"
   sleep 2
   sudo rm -rf /usr/bin/composer
   value="Composer";
elif [ $pil -eq 8 ];
then
   clear
   echo -e "\n\nReturn permissions for /var/www to root\n"
   sleep 2
   sudo chown -R root:root /var/www
   sleep 2
   echo -e "\nPermissions have been set\n"
   value="www-data Permissions";
elif [ $pil -eq 9 ];
then
   clear
   echo -e "\n\nTerima Kasih Telah Menggunakan script ini...\n"
   exit 0
else
   clear
   echo -e "\n\nSorry, Menu tidak tersedia\n"
   exit 1
fi
echo -e "\nUninstall $value Berhasil"
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