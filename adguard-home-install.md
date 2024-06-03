# Install Adguard Home DNS

Berikut cara memasang adguard-home dns manual.

## Install Adguard-home-dns

    sudo apt install snapd -y && snap install core && snap install adguard-home

## Fix Port 53 DNS Adguard Merah
Buat file **adguardhome.conf** 

    nano /etc/systemd/resolved.conf.d/adguardhome.conf
 
Isikan di dalam file **adguardhome.conf** dengan isi dibawah ini :

    [Resolve]
    DNS=127.0.0.1
    DNSStubListener=no

Lalu lakukan aktivasi config dan restart service adguard dengan command di bawah ini :

    sudo mv /etc/resolv.conf /etc/resolv.conf.backup && sudo ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf && sudo systemctl reload-or-restart systemd-resolved
