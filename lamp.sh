#!/bin/bash

# Memanggil banyak file bash dari folder include
source include/manage_script.sh
source include/headermenu.sh
source include/cockpit.sh
source include/check_package.sh
source include/apache2.sh
source include/nginx.sh
source include/domain_setup.sh
source include/php.sh
source include/mariadb.sh
source include/phpmyadmin.sh
source include/composer.sh
source include/wordpress.sh
source include/speedtest.sh
source include/server.sh

#cek root
cek_root

#cek available update
cek_con

#cek ditro
cek_distro

#cek available update on new server
cek_new

# terus tampilkan menu sampai pengguna memilih untuk keluar
while true; do
  # tampilkan header
  show_header

  # tampilkan menu utama
  show_menu
  read -p "Masukkan pilihan Anda: " choice

  case $choice in
    1) # Apache
      while true; do
      clear
      show_header
      show_apache_submenu
        read -p "Masukkan pilihan Anda: " apache_choice

        case $apache_choice in
          1) # Install Apache
            manage_apache install
            ;;
          2) # Uninstall Apache
            manage_apache uninstall
            ;;
          3) # Domain Setup
            manage_apache domainsetup
            sleep 2
            ;;
          4) # SSL Setup
            manage_apache ssl
            sleep 2
            ;;
          5) # SSL Renew
            manage_apache sslrenew
            sleep 2
            ;;
          6) # a2enmod Rewrite
            manage_apache a2enmod
            ;;
          7) # Restart Apache Services
            manage_apache restart
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
    2) # Nginx
      while true; do
      clear
      show_header
      show_nginx_submenu
        read -p "Masukkan pilihan Anda: " nginx_choice

        case $nginx_choice in
          1) # Install Nginx
            manage_nginx install
            ;;
          2) # Uninstall Nginx
            manage_nginx uninstall
            ;;
          3) # Domain Setup
            manage_nginx domainsetup
            ;;
          4) # SSL Setup
            manage_nginx ssl
            ;;
          5) # SSL Renew
            manage_nginx sslrenew
            ;;
          6) # a2enmod Rewrite
            manage_nginx a2enmod
            ;;
          7) # Restart Nginx Services
            manage_nginx restart
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
    3) # PHP
      while true; do
      clear
      show_header
      show_php_submenu
        read -p "Masukkan pilihan Anda: " php_choice

        case $php_choice in
          1) # Install PHP
            manage_php install
            ;;
          2) # Uninstall PHP
            manage_php uninstall
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
    4) # Mariadb
      while true; do
      clear
      show_header
      show_mariadb_submenu
        read -p "Masukkan pilihan Anda: " mariadb_choice

        case $mariadb_choice in
          1) # Install Mariadb
            manage_mariadb install
            ;;
          2) # Uninstall Mariadb
            manage_mariadb uninstall
            ;;
          3) # Manage User Mariadb
            manage_user
            ;;
          4) # Manage Database Mariadb
            manage_database
            ;;
          5) # Kembali ke menu utama
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
    5) # PhpMyAdmin
      while true; do
      clear
      show_header
      show_phpmyadmin_submenu
        read -p "Masukkan pilihan Anda: " phpmyadmin_choice

        case $phpmyadmin_choice in
          1) # Install PhpMyAdmin
            manage_phpmyadmin install
            ;;
          2) # Uninstall PhpMyAdmin
            manage_phpmyadmin uninstall
            ;;
          3) # Update PhpMyAdmin
            manage_phpmyadmin update
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
    6) # Composer
      while true; do
      clear
      show_header
      show_composer_submenu
        read -p "Masukkan pilihan Anda: " composer_choice

        case $composer_choice in
          1) # Install Composer
            manage_composer install
            ;;
          2) # Uninstall Composer
            manage_composer uninstall
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
    7) # Wordpress
      while true; do
      clear
      show_header
      show_wordpress_submenu
        read -p "Masukkan pilihan Anda: " wordpress_choice

        case $wordpress_choice in
          1) # Install Wordpress
            manage_wordpress install
            ;;
          2) # Uninstall Wordpress
            manage_wordpress uninstall
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
    8) # Cockpit
      while true; do
      clear
      show_header
      show_cockpit_submenu
        read -p "Masukkan pilihan Anda: " cockpit_choice

        case $cockpit_choice in
          1) # Install Cockpit
            manage_cockpit install
            ;;
          2) # Uninstall Cockpit
            manage_cockpit uninstall
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
    9) # Speedtest
      while true; do
      clear
      show_header
      show_speedtest_submenu
        read -p "Masukkan pilihan Anda: " speedtest_choice

        case $speedtest_choice in
          1) # Install Speedtest
            manage_speedtest install
            ;;
          2) # Uninstall Speedtest
            manage_speedtest uninstall
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
    10) # Manage Server
      while true; do
      clear
      show_header
      show_server_submenu
        read -p "Masukkan pilihan Anda: " server_choice

        case $server_choice in
          1) # APT Update &upgrade
            manage_server update
            ;;
          2) # Reboot Server
            manage_server reboot
            ;;
          3) # Poweroff Server
            manage_server poweroff
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
    11) # Keluar
      clear
      echo -e "\nTerima kasih telah menggunakan program ini.\n"
      sleep 2
      clear
      exit
      ;;
    *) # Input salah
      clear
      echo -e "\nPilihan tidak valid.\n"
      sleep 2
      ;;
  esac
done