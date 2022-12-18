# Install adm-linuxserver-webgui
Ada banyak beredar webgui untuk administarsi server linux. tapi yang bisa digunakan ada 2 yang sangat populer yakni : 

 1. Cockpit
 2. Webmin

Berikut Cara Install Keduanya :

## Cockpit
berikut adalah perintah install cockpit : 

    sudo apt install cockpit && sudo systemctl enable cockpit
Cek status service cockpit :

    sudo sudo systemctl status cockpit

## Webmin
berikut adalah perintah install webmin : 

    sudo apt install webmin && sudo systemctl enable webmin
Cek status service cockpit :

    sudo sudo systemctl status webmin
    
