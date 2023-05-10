# fungsi untuk menampilkan submenu Composer
show_speedtest_submenu() {
    echo "1. Install"
    echo "2. Uninstall"
    echo "3. Kembali ke menu utama"
}

# fungsi untuk proses Composer
manage_speedtest() {
    clear
    action=$1

  if [ "$action" == "install" ]; then
    #install speedtest
    read -p "Masukkan domain yang telah anda pasang di webserver: " DOMAIN
    DIRECTORY = /var/www/$DOMAIN/public_html
    read -p "Masukkan nama provider vps : " PROVIDER
    title="Speedtest $DOMAIN $PROVIDER Server"
  
    mv $DIRECTORY/* /var/www/$DOMAIN
    wget https://github.com/librespeed/speedtest/archive/refs/heads/master.zip
    unzip master.zip
    cp speedtest-master/* $DIRECTORY/
    rm -rf master.zip speedtest-master
    mv $DIRECTORY/example-singleServer-full.html $DIRECTORY/index.html

    sed -i "276s/LibreSpeed Example/$title/" index.html
    sed -i "279s/LibreSpeed Example/$title/" index.html
    sed -e '320d' index.html

  elif [ "$action" == "uninstall" ]; then
    #uninstall speedtest
    read -p "Masukkan domain yang telah anda pasang di webserver: " DOMAIN
    dir = /var/www/$DOMAIN/public_html
    clear
    echo -e "\nMengapus web speedtest"
    sleep 2
    rm -rf $DIRECTORY/*
    mv /var/www/$DOMAIN/* $DIRECTORY/
    echo -e "\nPengapusan web speedtest telah selesai"
  else
    echo "Perintah tidak valid."
  fi
}