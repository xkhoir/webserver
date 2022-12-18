# Build PHP Webserver Ubuntu / Debian

Berikut cara membuat webserver php manual.

## Tambah repo php
Eksekusi perintah berikut di terminal :

    sudo add-apt-repository ppa:ondrej/php
## Tambah repo phpmyadmin
Eksekusi perintah berikut di terminal :

    sudo add-apt-repository ppa:phpmyadmin/ppa
## Tambah repo mariadb
Tambahkan repo sesuai distro linux kamu di web [mariadb](https://mariadb.org/download/?t=repo-config).

Namun disini saya akan mencontohkan untuk distro ubuntu versi 22.04 "Jammy", dengan mengeksekusi perintah berikut :

    sudo apt-get install apt-transport-https curl
    sudo curl -o /etc/apt/trusted.gpg.d/mariadb_release_signing_key.asc 'https://mariadb.org/mariadb_release_signing_key.asc'
    sudo sh -c "echo 'deb https://download.nus.edu.sg/mirror/mariadb/repo/10.10/ubuntu jammy main' >>/etc/apt/sources.list"



## Update dan upgrade repo apt
Eksekusi perintah berikut di terminal :

    sudo apt update && sudo apt upgrade -y && reboot

## Install apache2 webserver
Eksekusi perintah berikut di terminal :

    sudo apt install apache2 -y

## Install php
Silahkan jika ingin merubah versi php yang kalian inginkan. **tinggal ganti angkanya !!**

Disini saya contohkan dengan versi **php8.1**, dengan mengeksekusi perintah berikut :

    sudo apt install php8.1 -y && sudo apt install libapache2-mod-php8.1 -y && sudo apt install php8.1-{bz2,cli,intl,common,mysql,zip,curl,gd,mbstring,xml,bcmath,phpdbg,cgi} -y

## Install database

Sebetulnya terserah untuk memakai database yang kamu inginkan. 
tetapi disini saya akan mencontohkan perintah untuk menginstall mysql dan mariadb.

Eksekusi perintah berikut di terminal untuk mysql-server :

    sudo apt install mysql-server -y && mysql_secure_installation

Eksekusi perintah berikut untuk mariadb-server :

    sudo apt install mariadb-server -y && mysql_secure_installation

## Install phpmyadmin
pada repo yang ditambahkan sebelumnya versi paling terbaru yang tersedia adalah **phpmyadmin 5.1.0**.
dengan mengeksekusi perintah berikut :

    sudo apt install phpmyadmin -y
    
## Update phpmyadmin terbaru
pada saat ini phpmyadmin ada di versi yang terbaru yaitu **phpmyadmin 5.2.0**
Backup file phpmyadmin lama dengan ext .bak, dengan mengeksekusi perintah berikut :

    sudo rm -rf /usr/share/phpmyadmin.bak && sudo mv /usr/share/phpmyadmin/ /usr/share/phpmyadmin.bak

Buat folder baru dan masuk kedalam direktori phpmyadmin dengan perintah berikut :

    sudo mkdir /usr/share/phpmyadmin/ && cd /usr/share/phpmyadmin/

Download dan extract phpmyadmin direct dengan perintah berikut :

    sudo wget https://files.phpmyadmin.net/phpMyAdmin/5.2.0/phpMyAdmin-5.2.0-all-languages.tar.gz && sudo tar xzf phpMyAdmin-5.2.0-all-languages.tar.gz && sudo mv phpMyAdmin-5.2.0-all-languages/* /usr/share/phpmyadmin && cp config.sample.inc.php config.inc.php

setelah itu kita berhasil masuk ke phpmyadmin dengan cara masuk ke 
http://*/phpmyadmin **ganti * dengan ip kamu sendiri !!**

ketika masuk kamu akan mendapat 2 error yaitu

 1. the configuration file now needs a secret passphrase (blowfish_secret).
 2. the $cfg['tempdir'] (/usr/share/phpmyadmin/tmp/) is not accessible. phpmyadmin is not able to cache templates and will be slow because of this.

ini terjadi karena file config.inc.php belum di konfigurasi. 
edit isinya dengan cara eksekusi perintah berikut : 

    sudo nano config.inc.php
isi blowfish_secret dengan mendapatkannya di [link ini](https://phpsolved.com/phpmyadmin-blowfish-secret-generator/?g=5d94be5065c70)

letakkan sesuai gambar dibawah : 
![enter image description here](pastelink)

dan tambahkan `$cfg['TempDir'] = '/tmp';` sesuai gambar dibawah :
![enter image description here](pastelink)

## Install composer direct
Eksekusi perintah berikut di terminal :

    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    php -r "if (hash_file('sha384', 'composer-setup.php') === '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
    php composer-setup.php
    php -r "unlink('composer-setup.php');"

Copy ke PATH untuk diakses global

versi /usr/bin :

    sudo mv composer.phar /usr/bin/composer

versi /usr/local/bin :

    sudo mv composer.phar /usr/bin/composer
