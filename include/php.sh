
# fungsi untuk menampilkan submenu PHP
show_php_submenu() {
    echo "1. Install"
    echo "2. Uninstall"
    echo "3. Kembali ke menu utama"
}

# fungsi untuk proses PHP
manage_php() {
  clear
  read -p "Masukkan versi PHP yang ingin diinstall (contoh: 7.4): " version

  package="php$version"
  action=$1
  # list of PHP extensions to install
  extensions=("fpm" "bz2" "cli" "intl" "common" "mysql" "zip" "curl" "gd" "mbstring" "xml" "bcmath" "phpdbg" "cgi")
  #extensions=("bcmath" "bz2" "cgi" "cli" "common" "curl" "dba" "dev" "enchant" "fpm" "gd" "gmp" "imap" "interbase" "intl" "json" "mbstring" "mysql" "odbc" "opcache" "pgsql" "phpdbg" "pspell" "readline" "snmp" "soap" "sqlite3" "sybase" "tidy" "xml" "xmlrpc" "xsl" "zip")

  if [ "$action" == "uninstall" ]; then
    a2dismod proxy_fcgi setenvif
    a2disconf $package-fpm //ganti sesuai versi php yang diinstall
    # Uninstall PHP & ekstensi
    for ext in "${extensions[@]}"; do
      ext_package="$package-$ext"
      #parsing data ke fungsi check_package
      check_package "$ext_package" "uninstall"
    done
    #hapus repo php
    add-apt-repository --remove ppa:ondrej/php
    #hapus direktori
    rm -rf /etc/php/*
    
  elif [ "$action" == "install" ]; then
    #install repo php
    sudo add-apt-repository ppa:ondrej/php
    # Instalasi PHP & ekstensi
    for ext in "${extensions[@]}"; do
      ext_package="$package-$ext"
      #parsing data ke fungsi check_package
      check_package "$ext_package" "install"
    done
    a2enmod proxy_fcgi setenvif
    a2enconf $package-fpm //ganti sesuai versi php yang diinstall
  else
    echo "Perintah tidak valid."
  fi
}
