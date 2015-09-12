define php5::generate_ssl_cert (
    $directory = '/etc/apache2/ssl',
    $domain       = 'app.lh',
) {

    exec { "mkdir -p ${directory}":
        path    => '/usr/bin:/bin:/usr/sbin:/sbin',
        command => "mkdir -p ${directory}",
    }

    exec { "openssl genrsa ${domain}":
        path    => '/usr/bin:/bin:/usr/sbin:/sbin',
        command => "openssl genrsa -des3 -passout pass:x -out ${directory}/${domain}.pass.key 2048",
        require => Exec["mkdir -p ${directory}"]
    }

    exec { "openssl rsa ${domain}":
        path    => '/usr/bin:/bin:/usr/sbin:/sbin',
        command => "openssl rsa -passin pass:x -in ${directory}/${domain}.pass.key -out ${directory}/${domain}.key",
        require => Exec["openssl genrsa ${domain}"]
    }

    exec { "openssl req ${domain}":
        path    => '/usr/bin:/bin:/usr/sbin:/sbin',
        command => "openssl req -new -key ${directory}/${domain}.key -out ${directory}/${domain}.csr -subj '/C=GB/ST=London/L=London/O=Some Organization/OU=IT Department/CN=${domain}'",
        require => Exec["openssl rsa ${domain}"]
    }

    exec { "openssl x509 ${domain}":
        path    => '/usr/bin:/bin:/usr/sbin:/sbin',
        command => "openssl x509 -req -days 365 -in ${directory}/${domain}.csr -signkey ${directory}/${domain}.key -out ${directory}/${domain}.crt",
        require => Exec["openssl req ${domain}"]
    }

}