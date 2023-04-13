<!DOCTYPE html>
<html>

<head>
    <title>Result vhost autoinstaller page</title>
    <style>
    .container {
        margin: auto;
        width: 60%;
        border: 1px solid #ccc;
        padding: 20px;
        border-radius: 10px;
        box-shadow: 2px 2px 5px #ccc;
    }

    .table {
        border-collapse: collapse;
        margin-top: 20px;
        width: 100%;
    }

    .table th,
    .table td {
        border: 1px solid #ccc;
        padding: 10px;
        text-align: center;
        background-color: #f7f7f7;
    }

    .table th {
        background-color: #6c757d;
        color: #fff;
        text-transform: uppercase;
        font-size: 14px;
        font-weight: bold;
        letter-spacing: 1px;
    }

    .table tr:nth-child(even) {
        background-color: #f2f2f2;
    }

    .table tr:hover {
        background-color: #e6e6e6;
    }

    .warning {
        color: red;
    }

    .success {
        color: green;
    }
    </style>
</head>

<body>
    <div class="container rounded">
        <h2 style="text-align: center;">Selamat! Domain <span class="success">RDOMAIN</span> sukses terinstall</h2>
        <table class="table">
            <tr>
                <th colspan="2">Web Server</th>
            </tr>
            <tr>
                <td><strong>Name</strong></td>
                <td><?php echo $_SERVER['SERVER_SOFTWARE']; ?></td>
            </tr>
            <tr>
                <td><strong>Port</strong></td>
                <td><?php echo $_SERVER['SERVER_PORT']; ?></td>
            </tr>
            <tr>
                <td><strong>Document Root</strong></td>
                <td><?php echo $_SERVER['DOCUMENT_ROOT']; ?></td>
            </tr>
            <tr>
                <?php
                if (strpos($_SERVER['SERVER_SOFTWARE'], 'Apache') !== false) {
                    // Jika web server adalah Apache, tampilkan kode yang diinginkan di sini
                    echo "<td><strong>Document Log</strong></td>";
                    echo "<td>RLOG/(access.log & error.log)</td>";
                }
                ?>
            </tr>
        </table>
        <table class="table">
            <tr>
                <th colspan="2">PHP</th>
            </tr>
            <tr>
                <td><strong>Version</strong></td>
                <?php
                // Menjalankan perintah "php -v" di shell dan menyimpan outputnya ke dalam variabel $output
                $output = shell_exec('php -v');

                if (strpos($output, 'PHP') !== false) {
                    // Jika string 'PHP' ditemukan dalam output, maka ambil versi PHP dengan fungsi phpversion() dan simpan ke dalam variabel $version
                    $version = explode('-', phpversion())[0];
                    // Tampilkan versi PHP di dalam tag HTML <td>
                    echo "<td class='success'>" . $version . "</td>";
                } else {
                    // Jika string 'PHP' tidak ditemukan dalam output, tampilkan pesan bahwa PHP tidak terinstall di dalam tag HTML <td> dengan atribut colspan="2"
                    echo "<td class='warning'>Tidak/Belum Terinstall.</td>";
                }
                ?>
            </tr>
            <tr>
                <td><strong>FPM Services</strong></td>
                <?php
                    // nama service PHP FPM
                    $service = 'php-fpm';
                    // menjalankan perintah "systemctl status" untuk mengecek status service
                    $output = shell_exec('systemctl status ' . $service);
                    if (strpos($output, 'Active: active (running)') !== false) {
                        $status = 'Aktif';
                        $class = 'success';
                      } else {
                        $status = 'Tidak/Belum Aktif';
                        $class = 'warning';
                      }
                      
                      echo '<td class="' . $class . '">' . $status . '</td>';
                ?>
            </tr>
        </table>
        <p style="text-align: center;">Kembangkan website Anda di Document Root</p>
        <p style="text-align: center;">Terima kasih telah memilih layanan Auto Domain Installer xkhoirtech.</p>
    </div>
</body>

</html>