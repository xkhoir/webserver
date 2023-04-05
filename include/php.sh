# Memanggil fungsi bash dari file yang berbeda
source check_package.sh

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

  if [ "$action" == "uninstall" ]; then
    add-apt-repository --remove ppa:ondrej/php
    #parsing data ke fungsi check_package
    check_package "$package" "uninstall"
    a2dismod proxy_fcgi setenvif
    a2disconf $package-fpm //ganti sesuai versi php yang diinstall

    # Uninstall ekstensi PHP
    extensions=("bz2" "cli" "intl" "common" "mysql" "zip" "curl" "gd" "mbstring" "xml" "bcmath" "phpdbg" "cgi")
    for ext in "${extensions[@]}"; do
      ext_package="$package-$ext"
      #parsing data ke fungsi check_package
      check_package "$ext_package" "uninstall"
    done
    
  elif [ "$action" == "install" ]; then
    sudo add-apt-repository ppa:ondrej/php
    #parsing data ke fungsi check_package
    check_package "$package" "install"
    a2enmod proxy_fcgi setenvif
    a2enconf $package-fpm //ganti sesuai versi php yang diinstall
    # Instalasi ekstensi PHP
    extensions=("bz2" "cli" "intl" "common" "mysql" "zip" "curl" "gd" "mbstring" "xml" "bcmath" "phpdbg" "cgi")
    for ext in "${extensions[@]}"; do
      ext_package="$package-$ext"
      #parsing data ke fungsi check_package
      check_package "$ext_package" "install"
    done
  else
    echo "Perintah tidak valid."
  fi
}

# fungsi untuk cek versi PHP yang digunakan
cek_php() {
  php_path=`which php`

  if [ $? -ne 0 ]
  then
    echo "PHP tidak terinstall pada sistem Anda"
    exit 1
  fi

  php_version=`$php_path -v | awk '/^PHP/ {print $2}'`

  if [ $? -eq 0 ]
  then
    echo "Versi PHP yang terinstall pada sistem Anda adalah $php_version"
  else
    echo "Gagal memeriksa versi PHP"
    exit 1
  fi
}

# contoh penggunaan fungsi
cek_php
