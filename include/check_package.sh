# fungsi cek paket apt yang dimasukkan 
#$1 ambil data kata pertama yaitu nama paket
#$2 ambil data kata kedua yaitu aksi Uninstall/Install
check_package() {
  if dpkg -s "$1" >/dev/null 2>&1; then
    if [ "$2" == "install" ]; then
      echo -e "\nPaket $1 telah terinstall, tidak perlu diinstall lagi."
      sleep 2
    elif [ "$2" == "uninstall" ]; then
      clear
      echo -e "\nMenguninstall paket $1 ..\n"
      apt remove --purge "$1"* -y
      sleep 1
      clear
      apt autoremove --purge -y
      sleep 1
      clear
      apt clean
      echo -e "\nPaket $1 suskses teruninstall\n"
      sleep 2
    else
      echo "Argumen kedua tidak valid. Harus menggunakan 'install' atau 'uninstall'."
      sleep 2
    fi
  else
    if [ "$2" == "install" ]; then
      clear
      echo -e "\nMenginstall paket $1 ..\n"
      sudo apt install "$1" -y
      echo -e "\nPaket $1 suskses terinstall\n"
      sleep 2
    elif [ "$2" == "uninstall" ]; then
      clear
      echo -e "\nPaket $1 belum terpasang, silahkan install dulu melalui opsi install.\n"
      sleep 3
    else
      clear
      echo -e "\nArgumen kedua tidak valid. Harus menggunakan 'install' atau 'uninstall'.\n"
      sleep 2
    fi
  fi
}