<!DOCTYPE html>
<html>

<head>
    <title>PHP Info</title>
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
                <td><strong>Document Log</strong></td>
                <?php
                if (strpos($_SERVER['SERVER_SOFTWARE'], 'Apache') !== false) {
                    // Jika web server adalah Apache, tampilkan kode yang diinginkan di sini
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
                if (function_exists('phpversion')) {
                    $php_version = phpversion();
                    if ($php_version) {
                        $php_version = strstr($php_version, '-', true); // Mengambil versi PHP sebelum karakter "-"
                        echo "<td class='success'>" . $php_version . "</td>";
                    } else {
                        echo "<td class='warning'>Tidak dapat menentukan versi</td>";
                    }
                } else {
                    echo "<td class='warning'>Tidak aktif/terinstall</td>";
                }
                ?>
            </tr>
            <tr>
                <td><strong>FPM Services</strong></td>
                <?php
                $fpm_modules = shell_exec("php-fpm7.4 -m"); // Ganti sesuai dengan versi PHP-FPM yang terinstall di sistem
                if (!empty($fpm_modules)) {
                    echo "<td class='success'>" . $fpm_modules . "</td>";
                } else {
                    echo "<td class='warning'>Tidak aktif/terinstall</td>";
                }
                ?>
            </tr>
        </table>
        <p style="text-align: center;">Kengembangkan website Anda di Document Root</p>
        <p style="text-align: center;">Terima kasih telah memilih layanan Auto Domain Installer xkhoirtech.</p>
    </div>
</body>

</html>