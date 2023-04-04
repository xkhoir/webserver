#!/bin/bash

# Memanggil banyak file bash dari folder include
source include/cek_root.sh
source include/headermenu.sh
source include/check_package.sh
source include/apache2.sh
source include/domainsetup.sh
source include/php.sh
source include/mariadb.sh
source include/phpmyadmin.sh
source include/composer.sh
source include/server.sh

#cek root
cek_root

# terus tampilkan menu sampai pengguna memilih untuk keluar
while true; do
  # tampilkan header
  show_header

  # tampilkan menu utama
  show_menu
  read -p "Masukkan pilihan Anda: " choice

  case $choice in
    1) # Apache
      clear
      show_header
      show_apache_submenu
      while true; do
        read -p "Masukkan pilihan Anda: " apache_choice

        case $apache_choice in
          1) # Install Apache
            manage_apache install
            # kembali ke submenu Apache
            clear
      	    show_header
            show_apache_submenu
            ;;
          2) # Uninstall Apache
            manage_apache uninstall
            # kembali ke submenu Apache
            clear
      	    show_header
            show_apache_submenu
            ;;
          3) # Domain Setup
            manage_apache domainsetup
            # kembali ke submenu Apache
            clear
      	    show_header
            show_apache_submenu
            ;;
          4) # SSL Setup
            manage_apache ssl
            # kembali ke submenu Apache
            clear
      	    show_header
            show_apache_submenu
            ;;
          5) # SSL Renew
            manage_apache sslrenew
            # kembali ke submenu Apache
            clear
      	    show_header
            show_apache_submenu
            ;;
          6) # a2enmod Rewrite
            manage_apache a2enmod
            # kembali ke submenu Apache
            clear
      	    show_header
            show_apache_submenu
            ;;
          7) # Restart Apache Services
            manage_apache restart
            # kembali ke submenu Apache
            clear
      	    show_header
            show_apache_submenu
            ;;
          8) # Kembali ke menu utama
	        clear
      	    show_header
            show_menu
            break
            ;;
          *) # Input salah
            clear
            echo -e "\nPilihan tidak valid.\n"
            sleep 2
            ;;
        esac
      done
      ;;
    2) # PHP
      clear
      show_header
      show_php_submenu
      while true; do
        read -p "Masukkan pilihan Anda: " php_choice

        case $php_choice in
          1) # Install PHP
            manage_php install
            # kembali ke submenu PHP
            clear
      	    show_header
            show_php_submenu
            ;;
          2) # Uninstall PHP
            manage_php uninstall
            # kembali ke submenu PHP
            clear
      	    show_header
            show_php_submenu
            ;;
          3) # Kembali ke menu utama
	        clear
      	    show_header
            show_menu
            break
            ;;
          *) # Input salah
            clear
            echo -e "\nPilihan tidak valid.\n"
            sleep 2
            ;;
        esac
      done
      ;;
    3) # Mariadb
      clear
      show_header
      show_mariadb_submenu
      while true; do
        read -p "Masukkan pilihan Anda: " mariadb_choice

        case $mariadb_choice in
          1) # Install Mariadb
            manage_mariadb install
            # kembali ke submenu Mariadb
            clear
      	    show_header
            show_mariadb_submenu
            ;;
          2) # Uninstall Mariadb
            manage_mariadb uninstall
            # kembali ke submenu Mariadb
            clear
      	    show_header
            show_mariadb_submenu
            ;;
          3) # Manage User Mariadb
            manage_user
            # kembali ke submenu Mariadb
            clear
      	    show_header
            show_mariadb_submenu
            ;;
          4) # Kembali ke menu utama
	        clear
      	    show_header
            show_menu
            break
            ;;
          *) # Input salah
            clear
            echo -e "\nPilihan tidak valid.\n"
            sleep 2
            ;;
        esac
      done
      ;;
    4) # PhpMyAdmin
      clear
      show_header
      show_phpmyadmin_submenu
      while true; do
        read -p "Masukkan pilihan Anda: " phpmyadmin_choice

        case $phpmyadmin_choice in
          1) # Install PhpMyAdmin
            manage_phpmyadmin install
            # kembali ke submenu PhpMyAdmin
            clear
      	    show_header
            show_phpmyadmin_submenu
            ;;
          2) # Uninstall PhpMyAdmin
            manage_phpmyadmin uninstall
            # kembali ke submenu PhpMyAdmin
            clear
      	    show_header
            show_phpmyadmin_submenu
            ;;
          3) # Update PhpMyAdmin
            manage_phpmyadmin update
            # kembali ke submenu PhpMyAdmin
            clear
      	    show_header
            show_phpmyadmin_submenu
            ;;
          4) # Kembali ke menu utama
	        clear
      	    show_header
            show_menu
            break
            ;;
          *) # Input salah
            clear
            echo -e "\nPilihan tidak valid.\n"
            sleep 2
            ;;
        esac
      done
      ;;
    5) # Composer
      clear
      show_header
      show_composer_submenu
      while true; do
        read -p "Masukkan pilihan Anda: " composer_choice

        case $composer_choice in
          1) # Install Composer
            manage_composer install
            # kembali ke submenu Composer
            clear
      	    show_header
            show_composer_submenu
            ;;
          2) # Uninstall Composer
            manage_composer uninstall
            # kembali ke submenu Composer
            clear
      	    show_header
            show_composer_submenu
            ;;
          3) # Kembali ke menu utama
	        clear
      	    show_header
            show_menu
            break
            ;;
          *) # Input salah
            clear
            echo -e "\nPilihan tidak valid.\n"
            sleep 2
            ;;
        esac
      done
      ;;
    6) # Server
      clear
      show_header
      show_server_submenu
      while true; do
        read -p "Masukkan pilihan Anda: " server_choice

        case $server_choice in
          1) # Install Server
            manage_server reboot
            # kembali ke submenu Server
            clear
      	    show_header
            show_server_submenu
            ;;
          2) # Uninstall Server
            manage_server poweroff
            # kembali ke submenu Server
            clear
      	    show_header
            show_server_submenu
            ;;
          3) # Kembali ke menu utama
	        clear
      	    show_header
            show_menu
            break
            ;;
          *) # Input salah
            clear
            echo -e "\nPilihan tidak valid.\n"
            sleep 2
            ;;
        esac
      done
      ;;
    7) # Keluar
      clear
      echo -e "\nTerima kasih telah menggunakan program ini.\n"
      sleep 2
      exit
      ;;
    *) # Input salah
      clear
      echo -e "\nPilihan tidak valid.\n"
      sleep 2
      ;;
  esac
done