# fungsi untuk menampilkan submenu Manage server
show_server_submenu() {
    echo "1. Reboot"
    echo "2. Poweroff"
    echo "3. Kembali ke menu utama"
}

# fungsi untuk proses manage server
manage_server() {
    clear
    action=$1
  if [ "$action" == "reboot" ]; then
    #perintah reboot linux
    sudo reboot
  elif [ "$action" == "poweroff" ]; then
    #perintah poweroff linux
    sudo poweroff
  else
    echo "Perintah tidak valid."
  fi
}