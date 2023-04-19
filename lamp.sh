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
            # kembali ke submenu Apache
            # clear
      	    # show_header
            # show_apache_submenu
            ;;
          2) # Uninstall Apache
            manage_apache uninstall
            # kembali ke submenu Apache
            # clear
      	    # show_header
            # show_apache_submenu
            ;;
          3) # Domain Setup
            manage_apache domainsetup
            sleep 2
            # kembali ke submenu Apache
            # clear
      	    # show_header
            # show_apache_submenu
            ;;
          4) # SSL Setup
            manage_apache ssl
            sleep 2
            # kembali ke submenu Apache
            # clear
      	    # show_header
            # show_apache_submenu
            ;;
          5) # SSL Renew
            manage_apache sslrenew
            sleep 2
            # kembali ke submenu Apache
            # clear
      	    # show_header
            # show_apache_submenu
            ;;
          6) # a2enmod Rewrite
            manage_apache a2enmod
            # kembali ke submenu Apache
            # clear
      	    # show_header
            # show_apache_submenu
            ;;
          7) # Restart Apache Services
            manage_apache restart
            # kembali ke submenu Apache
            # clear
      	    # show_header
            # show_apache_submenu
            ;;
          8) # Kembali ke menu utama
	          # clear
      	    # show_header
            # show_menu
            break
            ;;
          *) # Input salah
            clear
            echo -e "\nPilihan tidak valid.\n"
            sleep 2
            # clear
            # show_header
            # show_apache_submenu
            ;;
        esac
      done
      ;;
    2) # Nginx
      clear
      show_header
      show_nginx_submenu
      while true; do
        read -p "Masukkan pilihan Anda: " nginx_choice

        case $nginx_choice in
          1) # Install Nginx
            manage_nginx install
            # kembali ke submenu Nginx
            clear
      	    show_header
            show_nginx_submenu
            ;;
          2) # Uninstall Nginx
            manage_nginx uninstall
            # kembali ke submenu Nginx
            clear
      	    show_header
            show_nginx_submenu
            ;;
          3) # Domain Setup
            manage_nginx domainsetup
            # kembali ke submenu Nginx
            clear
      	    show_header
            show_nginx_submenu
            ;;
          4) # SSL Setup
            manage_nginx ssl
            # kembali ke submenu Nginx
            clear
      	    show_header
            show_nginx_submenu
            ;;
          5) # SSL Renew
            manage_nginx sslrenew
            # kembali ke submenu Nginx
            clear
      	    show_header
            show_nginx_submenu
            ;;
          6) # a2enmod Rewrite
            manage_nginx a2enmod
            # kembali ke submenu Nginx
            clear
      	    show_header
            show_nginx_submenu
            ;;
          7) # Restart Nginx Services
            manage_nginx restart
            # kembali ke submenu Nginx
            clear
      	    show_header
            show_nginx_submenu
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
            clear
            show_header
            show_nginx_submenu
            ;;
        esac
      done
      ;;
    3) # PHP
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
            clear
            show_header
            show_php_submenu
            ;;
        esac
      done
      ;;
    4) # Mariadb
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
            clear
            show_header
            show_mariadb_submenu
            ;;
        esac
      done
      ;;
    5) # PhpMyAdmin
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
            clear
            show_header
            show_phpmyadmin_submenu
            ;;
        esac
      done
      ;;
    6) # Composer
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
            clear
      	    show_header
            show_composer_submenu
            ;;
        esac
      done
      ;;
    7) # Wordpress
      clear
      show_header
      show_wordpress_submenu
      while true; do
        read -p "Masukkan pilihan Anda: " wordpress_choice

        case $wordpress_choice in
          1) # Install Wordpress
            manage_wordpress install
            # kembali ke submenu Wordpress
            clear
      	    show_header
            show_wordpress_submenu
            ;;
          2) # Uninstall Wordpress
            manage_wordpress uninstall
            # kembali ke submenu Wordpress
            clear
      	    show_header
            show_wordpress_submenu
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
            clear
      	    show_header
            show_wordpress_submenu
            ;;
        esac
      done
      ;;
    8) # Cockpit
      clear
      show_header
      show_cockpit_submenu
      while true; do
        read -p "Masukkan pilihan Anda: " cockpit_choice

        case $cockpit_choice in
          1) # Install Cockpit
            manage_cockpit install
            # kembali ke submenu Cockpit
            clear
      	    show_header
            show_cockpit_submenu
            ;;
          2) # Uninstall Cockpit
            manage_cockpit uninstall
            # kembali ke submenu Cockpit
            clear
      	    show_header
            show_cockpit_submenu
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
            clear
      	    show_header
            show_cockpit_submenu
            ;;
        esac
      done
      ;;
    9) # Manage Server
      clear
      show_header
      show_server_submenu
      while true; do
        read -p "Masukkan pilihan Anda: " server_choice

        case $server_choice in
          1) # APT Update &upgrade
            manage_server update
            # kembali ke submenu Server
            clear
      	    show_header
            show_server_submenu
            ;;
          2) # Reboot Server
            manage_server reboot
            # kembali ke submenu Server
            clear
            ;;
          3) # Poweroff Server
            manage_server poweroff
            # kembali ke submenu Server
            clear
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
            clear
            show_header
            show_server_submenu
            ;;
        esac
      done
      ;;
    10) # Keluar
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