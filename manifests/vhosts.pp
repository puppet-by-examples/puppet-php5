#
# This definition should be named filefetcher::multi_fetch
#

define php5::vhosts () {

    include stdlib

    if is_hash($name) and has_key($name, 'domain') and has_key($name, 'rootdir') {

        $domainParameter = $name['domain']
        $dirParameter = $name['rootdir']

        openssl::certificate::x509 { $domainParameter:
            country      => 'PL',
            organization => 'Memorize IT!',
            commonname   => $domainParameter,
        }


        apache::vhost { $domainParameter:
            port          => '80',
            docroot       => $dirParameter,
            docroot_owner => 'www-data',
            docroot_group => 'www-data',
            notify        => Service['apache2'],
            directories   => [
                {
                    path           => $dirParameter,
                    allow_override => ['All'],
                },
            ],
        }

        apache::vhost { "https ${domainParameter}":
            servername    => $domainParameter,
            port          => '443',
            ssl           => true,
            ssl_cert      => "/etc/ssl/certs/${domainParameter}.crt",
            ssl_key       => "/etc/ssl/certs/${domainParameter}.key",
            docroot       => $dirParameter,
            docroot_owner => 'www-data',
            docroot_group => 'www-data',
            notify        => Service['apache2'],
            directories   => [
                {
                    path           => $dirParameter,
                    allow_override => ['All'],
                },
            ],
        }

        host { $domainParameter:
            ip => '127.0.0.1'
        }

    } else {
        fail('ERROR #1 in php5:vhosts')
    }

}