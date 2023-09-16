
# Fungsi untuk menampilkan submenu Caddy
show_caddy_submenu() {
    echo "1. Install"
    echo "2. Uninstall"
    echo "3. Tambah Domain ke Caddyfile"
    echo "4. Tambah Domain dengan Proxy ke Caddyfile"
    echo "5. Hapus Domain dari Caddyfile"
    echo "6. Restart Caddy"
    echo "7. Kembali ke menu utama"
}

# Fungsi untuk mengelola blok Caddy
manage_caddy_block() {
    action=$1
    # Path ke Caddyfile
    caddyfile_path="/etc/caddy/Caddyfile"
    clear
    case $action in
        "adddomain")
            # Meminta input domain dari pengguna
            read -p "Masukkan nama domain: " domain
            # Cek apakah Caddyfile ada atau tidak
            if [ ! -f "$caddyfile_path" ]; then
                echo "$caddyfile_path tidak ditemukan. Membuat file baru..."
                sleep 2
                echo -e "$domain{\n\troot * /var/www/$domain/public_html\n\tencode gzip\n\tphp_fastcgi unix//run/php/$domain.sock\n\tfile_server\n}\n" > "$caddyfile_path"
                echo "Caddyfile telah dibuat dengan konfigurasi untuk $domain"
                sleep 2
            else
                # Cek apakah domain sudah ada dalam Caddyfile
                if grep -q "$domain" "$caddyfile_path"; then
                    echo "Domain $domain sudah ada dalam Caddyfile."
                    sleep 2
                else
                    # Cari baris terakhir dalam Caddyfile
                    last_line=$(grep -nE "^}" "$caddyfile_path" | tail -n 1 | cut -d ":" -f 1)
                    # Cek apakah Caddyfile kosong
                    if [ -z "$last_line" ]; then
                        echo "Caddyfile Kosong, Menambahkan blok baru..."
                        sleep 2
                        echo -e "$domain{\n\troot * /var/www/$domain/public_html\n\tencode gzip\n\tphp_fastcgi unix//run/php/$domain.sock\n\tfile_server\n}\n" > "$caddyfile_path"
                        echo "Caddyfile telah diisi dengan konfigurasi untuk $domain"
                        sleep 2
                    else
                        # Menambahkan blok konfigurasi setelah baris terakhir
                        sed -i "${last_line}a\\ \n$domain{\n\troot * /var/www/$domain/public_html\n\tencode gzip\n\tphp_fastcgi unix//run/php/$domain.sock\n\tfile_server\n}\n" "$caddyfile_path"
                        echo "Konfigurasi untuk $domain telah ditambahkan ke Caddyfile"
                        sleep 2
                    fi
                fi
            fi
            ;;
        "addproxydomain")
            # Meminta input domain dari pengguna
            read -p "Masukkan nama domain: " domain
            read -p "Masukkan domain/ip tujuan " destination
            read -p "Masukkan port tujuan: " port
            # Cek apakah Caddyfile ada atau tidak
            if [ ! -f "$caddyfile_path" ]; then
                echo "$caddyfile_path tidak ditemukan. Membuat file baru..."
                echo -e "$domain{\n\treverse_proxy $destination:$port\n}\n" > "$caddyfile_path"
                echo "Caddyfile telah dibuat dengan konfigurasi untuk $domain"
            else
                # Cek apakah domain sudah ada dalam Caddyfile
                if grep -q "$domain" "$caddyfile_path"; then
                    echo "Domain $domain sudah ada dalam Caddyfile."
                    sleep 2
                else
                    # Cari baris terakhir dalam Caddyfile
                    last_line=$(grep -nE "^}" "$caddyfile_path" | tail -n 1 | cut -d ":" -f 1)

                    # Cek apakah Caddyfile kosong
                    if [ -z "$last_line" ]; then
                        echo "Caddyfile Kosong, Menambahkan blok baru..."
                        echo -e "$domain{\n\treverse_proxy $destination:$port\n}\n" > "$caddyfile_path"
                        echo "Caddyfile telah diisi dengan konfigurasi untuk $domain"
                    else
                        # Menambahkan blok konfigurasi setelah baris terakhir
                        sed -i "${last_line}a\\ \n$domain{\n\treverse_proxy $destination:$port\n}\n" "$caddyfile_path"
                        echo "Konfigurasi untuk $domain telah ditambahkan ke Caddyfile"
                    fi
                fi
            fi
            ;;
		"deletedomain")
            # Meminta input domain yang akan dihapus dari pengguna
            read -p "Masukkan nama domain yang akan dihapus: " domain
            # Cek apakah Caddyfile ada atau tidak
            if [ ! -f "$caddyfile_path" ]; then
                echo "Caddyfile tidak ditemukan."
                sleep 2
            else
                # Cek apakah domain sudah ada dalam Caddyfile
                if grep -q "$domain" "$caddyfile_path"; then
                    echo "Domain $domain ada dalam Caddyfile."
                    sleep 2
                else
                    # Cari baris terakhir dalam Caddyfile
                    last_line=$(grep -nE "^}" "$caddyfile_path" | tail -n 1 | cut -d ":" -f 1)

                    # Cek apakah Caddyfile kosong
                    if [ -z "$last_line" ]; then
                        echo "Caddyfile sudah kosong"
                    else
                        # Hapus konfigurasi domain dari Caddyfile
                        sed -i "/$domain{/,/}/d" "$caddyfile_path"
                        echo "Konfigurasi untuk $domain telah dihapus dari Caddyfile"
                    fi
                fi
            fi
            ;;
        *)
            echo "Perintah tidak valid."
            ;;
    esac
}

# Fungsi untuk proses Caddy
manage_caddy() {
    clear
    package="caddy"
    action=$1
    if [ "$action" == "uninstall" ]; then
        # Parsing data ke fungsi check_package
        check_package "$package" "$action"
    elif [ "$action" == "install" ]; then
        # Parsing data ke fungsi check_package
        check_package "$package" "$action"
    elif [ "$action" == "adddomain" ]; then
        domain_setup "adddomain"
    elif [ "$action" == "addproxydomain" ]; then
        domain_setup "addproxydomain"
    elif [ "$action" == "deletedomain" ]; then
        domain_setup "deletedomain"
    elif [ "$action" == "restart" ]; then
        # Proses restart/reload caddy service
        echo -e "Restart/reload service $package\n"
        sleep 2
        sudo systemctl reload $package
        sudo systemctl restart $package
    else
        echo "Perintah tidak valid."
    fi
}