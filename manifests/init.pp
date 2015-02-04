class php5 (
    $username = 'vagrant'
) {

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

    exec { 'php5:update-php-add-repository':
        command => 'add-apt-repository ppa:ondrej/php5',
        path    => '/usr/bin:/usr/sbin:/bin',
        require => Package['python-software-properties']
    }

    exec { 'php5:apt-get-update':
        path    => '/usr/bin',
        command => 'apt-get update -y',
        require => Exec['php5:update-php-add-repository']
    }

    package { 'php5':
        ensure  => installed,
        require => Exec['php5:apt-get-update']
    }

    package { 'php5-curl':
        ensure  => installed,
        require => Package['php5', 'libcurl3', 'libcurl3-dev']
    }

    package { 'php5-xdebug':
        ensure  => installed,
        require => Package['php5']
    }

    package { 'php5-xsl':
        ensure  => installed,
        require => Package['php5']
    }

    package { 'php5-mysql':
        ensure  => installed,
        require => Package['php5']
    }

    exec { 'php5:mod-rewrite':
        path    => '/usr/bin:/usr/sbin:/bin',
        command => 'a2enmod rewrite',
        require => Package['php5'],
        notify  => Exec['php5:restart']
    }

    exec { 'php5:restart':
        path    => '/usr/bin:/usr/sbin:/bin',
        command => 'service apache2 restart',
        require => Package['php5']
    }

    file_line { 'apache_user':
        path    => '/etc/apache2/envvars',
        line    => "export APACHE_RUN_USER=${username}",
        match   => 'export APACHE_RUN_USER=www-data',
        require => Package['php5'],
        notify  => Exec['php5:restart']
    }

    file_line { 'apache_group':
        path    => '/etc/apache2/envvars',
        line    => "export APACHE_RUN_GROUP=${username}",
        match   => 'export APACHE_RUN_GROUP=www-data',
        require => Package['php5'],
        notify  => Exec['php5:restart']
    }

    file_line { 'apache2-enable-htaccess-files':
        path     => '/etc/apache2/apache2.conf',
        match    => '^\s*AllowOverride None',
        multiple => true,
        line     => "\tAllowOverride All",
        require  => Package['php5'],
        notify   => Exec['php5:restart']
    }

    file_line { 'php5_apache2_short_open_tag':
        path    => '/etc/php5/apache2/php.ini',
        match   => 'short_open_tag =',
        line    => 'short_open_tag = Off',
        require => Package['php5'],
        notify  => Exec['php5:restart']
    }

    file_line { 'php5_cli_short_open_tag':
        path    => '/etc/php5/cli/php.ini',
        match   => 'short_open_tag =',
        line    => 'short_open_tag = Off',
        require => Package['php5'],
        notify  => Exec['php5:restart']
    }

    file_line { 'php5_apache2_date_timezone':
        path    => '/etc/php5/apache2/php.ini',
        match   => 'date.timezone =',
        line    => 'date.timezone = Europe/Warsaw',
        require => Package['php5'],
        notify  => Exec['php5:restart']
    }

    file_line { 'php5_cli_date_timezone':
        path    => '/etc/php5/cli/php.ini',
        match   => 'date.timezone =',
        line    => 'date.timezone = Europe/Warsaw',
        require => Package['php5'],
        notify  => Exec['php5:restart']
    }

    file_line { 'php-apache-realpath-cache-size':
        path    => '/etc/php5/apache2/php.ini',
        match   => 'realpath_cache_size =',
        line    => 'realpath_cache_size = 8M',
        require => Package['php5'],
        notify  => Exec['php5:restart']
    }

    file_line { 'php-apache-realpath-cache-ttl':
        path    => '/etc/php5/apache2/php.ini',
        match   => 'realpath_cache_ttl =',
        line    => 'realpath_cache_ttl = 7200',
        require => Package['php5'],
        notify  => Exec['php5:restart']
    }

}
