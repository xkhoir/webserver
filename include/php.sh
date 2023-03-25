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
    #parsing data ke fungsi check_package
    check_package "$package" "uninstall"

    # Uninstall ekstensi PHP
    extensions=("bz2" "cli" "intl" "common" "mysql" "zip" "curl" "gd" "mbstring" "xml" "bcmath" "phpdbg" "cgi")
    for ext in "${extensions[@]}"; do
      ext_package="$package-$ext"
      #parsing data ke fungsi check_package
      check_package "$ext_package" "uninstall"
    done
  elif [ "$action" == "install" ]; then
    #parsing data ke fungsi check_package
    check_package "$package" "install"

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