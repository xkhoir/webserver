# fungsi untuk menampilkan submenu Manage server
show_server_submenu() {
    echo "1. APT update & upgrade"
    echo "2. Reboot"
    echo "3. Poweroff"
    echo "4. Kembali ke menu utama"
}

# fungsi untuk proses manage server
manage_server() {
    clear
    action=$1
  if [ "$action" == "reboot" ]; then
    #perintah reboot linux
    reboot
  elif [ "$action" == "poweroff" ]; then
    #perintah poweroff linux
    poweroff
  elif [ "$action" == "update" ]; then
    #perintah poweroff linux
    apt update 
    clear
    apt upgrade -y
  elif [ "$action" == "update" ]; then
    #perintah poweroff linux
    apt -qq update && apt -qq upgrade -y
  else
    echo "Perintah tidak valid."
  fi
}