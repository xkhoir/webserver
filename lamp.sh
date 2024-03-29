#!/bin/bash

# Memanggil banyak file bash dari folder include
source include/manage_script.sh
source include/headermenu.sh
source include/cockpit.sh
source include/check_package.sh
source include/domain_setup.sh
source include/apache2.sh
source include/caddy.sh
source include/nginx.sh
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
#cek_distro

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
          3) # adddomain
            manage_apache adddomain
            sleep 2
            ;;
          4) # addproxydomain
            manage_apache addproxydomain
            sleep 2
            ;;
          5) # deletedomain
            manage_apache deletedomain
            sleep 2
            ;;
          6) # SSL Setup
            manage_apache ssl
            sleep 2
            ;;
          7) # SSL Renew
            manage_apache sslrenew
            sleep 2
            ;;
          8) # a2enmod Rewrite
            manage_apache a2enmod
            ;;
          9) # Restart Apache Services
            manage_apache restart
            ;;
          10) # Kembali ke menu utama
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
          3) # adddomain
            manage_nginx adddomain
            sleep 2
            ;;
          4) # addproxydomain
            manage_nginx addproxydomain
            sleep 2
            ;;
          5) # deletedomain
            manage_nginx deletedomain
            sleep 2
            ;;
          6) # SSL Setup
            manage_nginx ssl
            ;;
          7) # SSL Renew
            manage_nginx sslrenew
            ;;
          8) # Restart Nginx Services
            manage_nginx restart
            ;;
          9) # Kembali ke menu utama
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
    3) # Caddy
      while true; do
      clear
      show_header
      show_caddy_submenu
        read -p "Masukkan pilihan Anda: " caddy_choice

        case $caddy_choice in
          1) # Install Caddy
            manage_caddy install
            ;;
          2) # Uninstall Cadyy
            manage_caddy uninstall
            ;;
          3) # Caddy add domain blok
            manage_caddy adddomain
            ;;
          4) # Caddy add proxy domain blok
            manage_caddy addproxydomain
            ;;
          5) # Caddy delete domain blok
            manage_caddy deletedomain
            ;;
          6) # Restart Caddy Services
            manage_caddy restart
            ;;
          7) # Kembali ke menu utama
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
    4) # PHP
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
    5) # Mariadb
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
    6) # PhpMyAdmin
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
    7) # Composer
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
    8) # Wordpress
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
    9) # Cockpit
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
    10) # Speedtest
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
    11) # Manage Server
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
    12) # Keluar
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
