class php5 {

    if defined(Package['python-software-properties']) == false {
        package { 'python-software-properties': ensure => present }
    }

    if defined(Package['curl']) == false {
        package { 'curl': ensure => present }
    }

    if defined(Package['libcurl3']) == false {
        package { 'libcurl3': ensure => present }
    }

    if defined(Package['libcurl3-dev']) == false {
        package { 'libcurl3-dev': ensure => present }
    }

    if defined(Package['acl']) == false {
        package { 'acl': ensure => present }
    }

    if defined(Package['git']) == false {
        package { 'git': ensure => present }
    }

    if defined(Package['lynx-cur']) == false {
        package { 'lynx-cur': ensure => present }
    }
  
    exec { 'php5:update-php-add-repository':
        command => "add-apt-repository ppa:ondrej/php5",
        path => '/usr/bin:/usr/sbin:/bin',
        require => [Package['python-software-properties']]
    }

    exec { 'php5:apt-get-update':
        path => '/usr/bin',
        command => 'apt-get update -y',
        require => [Exec['php5:update-php-add-repository']]
    }

    package { 'php5':
        ensure => installed,
        require => [Exec['php5:apt-get-update']]
    }

    package { 'php5-curl':
        ensure => installed,
        require => [Package['libcurl3', 'libcurl3-dev']]
    }

    exec { 'php5:mod-rewrite':
        path => '/usr/bin:/usr/sbin:/bin',
        command => 'a2enmod rewrite',
        require => [Package['php5']]
    }

    exec { 'php5:restart':
        path => '/usr/bin:/usr/sbin:/bin',
        command => 'service apache2 restart',
#        require => [Exec['php5:mod-rewrite'], File['/var/www/html', '/etc/apache2/apache2.conf']]
        require => [Exec['php5:mod-rewrite'], File['/var/www/html']]
    }

    file { '/var/www/html':
        path => '/var/www/html',
        ensure => link,
        force => true,
        target => '/vagrant/web',
        require => [Package['php5']]
    }

#    file { '/etc/apache2/apache2.conf':
#        ensure => file,
#        mode   => 644,
#        source => '/vagrant/apache2.conf',
#        require => [Package['php5']]
#    }

    exec { 'php-cli-set-timezone':
        path => '/usr/bin:/usr/sbin:/bin',
        command => 'sed -i \'s/^[; ]*date.timezone =.*/date.timezone = Europe\/London/g\' /etc/php5/cli/php.ini',
        onlyif => 'test "`php -c /etc/php5/cli/php.ini -r \"echo ini_get(\'date.timezone\');\"`" = ""',
        require => [Package['php5']]
    }

    exec { 'php-cli-set-phar-options':
        path => '/usr/bin:/usr/sbin:/bin',
        command => 'sed -i \'s/^[; ]*;phar.readonly *= *.*/phar.readonly = 0/g\' /etc/php5/cli/php.ini',
        require => [Package['php5']]
    }

    exec { 'php-cli-disable-short-open-tag':
        path => '/usr/bin:/usr/sbin:/bin',
        command => 'sed -i \'s/^[; ]*short_open_tag =.*/short_open_tag = Off/g\' /etc/php5/cli/php.ini',
        onlyif => 'test "`php -c /etc/php5/cli/php.ini -r \"echo ini_get(\'short_open_tag\');\"`" = "1"',
        require => [Package['php5']]
    }

}
