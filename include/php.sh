
# fungsi untuk menampilkan submenu PHP
show_php_submenu() {
    echo "1. Install"
    echo "2. Uninstall"
    echo "3. Kembali ke menu utama"
}

# fungsi untuk proses PHP
manage_php() {
  clear
  read -p "Masukkan versi PHP (contoh: 7.4/8.0/8.1/8.2): " version

  package="php$version"
  action=$1
  # list of PHP extensions to install
  #extensions=("fpm" "bz2" "cli" "intl" "common" "mysql" "zip" "curl" "gd" "mbstring" "xml" "bcmath" "phpdbg" "cgi")
  #extensions=("bcmath" "bz2" "cgi" "cli" "common" "curl" "dba" "dev" "enchant" "fpm" "gd" "gmp" "imap" "interbase" "intl" "json" "mbstring" "mysql" "odbc" "opcache" "pgsql" "phpdbg" "pspell" "readline" "snmp" "soap" "sqlite3" "sybase" "tidy" "xml" "xmlrpc" "xsl" "zip")

  if [ "$action" == "uninstall" ]; then
    a2dismod proxy_fcgi setenvif
    a2disconf $package-fpm
    check_package "$package-fpm" "$action"
    # Uninstall PHP & ekstensi
    # for ext in "${extensions[@]}"; do
    #   ext_package="$package-$ext"
    #   #parsing data ke fungsi check_package
    #   check_package "$ext_package" "uninstall"
    # done
    #hapus repo php
    if grep -q "^deb .*ondrej/php" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
        echo "Repo ondrej/php terinstal."

        read -p "Apakah Anda ingin menghapus repo? [y/n]: " answer
        case "$answer" in
            [yY])
                echo "Menghapus repo ondrej/php..."
                sleep 3
                sudo add-apt-repository -y --remove ppa:ondrej/php
                ;;
            [nN])
                echo "Melewati penghapusan repo ondrej/php."
                sleep 3
                ;;
            *)
                echo "Input tidak valid. Melewati penghapusan repo ondrej/php."
                sleep 2
                ;;
        esac
    else
        echo "Repo ondrej/php tidak terinstal. Melewati..."
        sleep 2
    fi
    #hapus direktori
    rm -rf /etc/php/$version
    
  elif [ "$action" == "install" ]; then
    #install repo php
    # if ! grep -q "^deb .*ondrej/php" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    #   #echo "Repo ondrej/php tidak terinstal. Menambahkan repo..."
    #   add-apt-repository -y ppa:ondrej/php
    # fi

    check_package "$package-fpm" "$action"
    apt install $package-{bz2,cli,intl,common,mysql,zip,curl,gd,mbstring,xml,bcmath,phpdbg,cgi} -y
    # Instalasi PHP & ekstensi
    # for ext in "${extensions[@]}"; do
    #   ext_package="$package-$ext"
    #   #parsing data ke fungsi check_package
    #   check_package "$ext_package" "install"
    # done
    a2enmod proxy_fcgi setenvif
    a2enconf $package-fpm
  else
    echo "Perintah tidak valid."
  fi
}
