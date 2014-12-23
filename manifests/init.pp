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

    if defined(Package['apache2-utils']) == false {
        package { 'apache2-utils': ensure => present }
    }

    if defined(Package['tree']) == false {
        package { 'tree': ensure => present }
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
        require => [Package['php5', 'libcurl3', 'libcurl3-dev']]
    }

    package { 'php5-xdebug':
      ensure => installed,
      require => Package['php5']
    }

    package { 'php5-xsl':
      ensure => installed,
      require => Package['php5']
    }

    package { 'php5-mysql':
      ensure => installed,
      require => Package['php5']
    }

    exec { 'php5:mod-rewrite':
        path => '/usr/bin:/usr/sbin:/bin',
        command => 'a2enmod rewrite',
        require => [Package['php5']],
        notify  => Exec['php5:restart']
    }

    exec { 'php5:restart':
        path => '/usr/bin:/usr/sbin:/bin',
        command => 'service apache2 restart',
#        require => [Exec['php5:mod-rewrite'], File['/var/www/html', '/etc/apache2/apache2.conf']]
#        require => [Exec['php5:mod-rewrite'], File['/var/www/html']]
        require => [Package['php5']],
    }

    file { '/var/www/html':
        path => '/var/www/html',
        ensure => link,
        force => true,
        target => '/vagrant/web',
        require => [Package['php5']],
        notify  => Exec['php5:restart']
    }

#    file { '/etc/apache2/apache2.conf':
#        ensure => file,
#        mode   => 644,
#        source => '/vagrant/apache2.conf',
#        require => [Package['php5']]
#    }

    file_line { 'apache_user':
        path    => '/etc/apache2/envvars',
        line    => 'export APACHE_RUN_USER=vagrant',
        match   => 'export APACHE_RUN_USER=www-data',
        require => Package['php5'],
        notify  => Exec['php5:restart']
    }

    file_line { 'apache_group':
        path    => '/etc/apache2/envvars',
        line    => 'export APACHE_RUN_GROUP=vagrant',
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

#    exec { 'apache-enable-htaccess-files':
#        path => '/usr/bin:/usr/sbin:/bin',
#        command => 'sed -i \'s/AllowOverride None/AllowOverride All/g\' /etc/apache2/apache2.conf',
#        require => [Package['php5']]
#    }

# https://github.com/symfony/symfony-standard/blob/e8bffd160e3e73423565f5eba68a8b77f04c6f99/vagrant/puppet/manifests/symfony.pp

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

#    exec { 'php-cli-set-timezone':
#        path => '/usr/bin:/usr/sbin:/bin',
#        command => 'sed -i \'s/^[; ]*date.timezone =.*/date.timezone = Europe\/London/g\' /etc/php5/cli/php.ini',
#        onlyif => 'test "`php -c /etc/php5/cli/php.ini -r \"echo ini_get(\'date.timezone\');\"`" = ""',
#        require => [Package['php5']]
#    }

#    exec { 'php-cli-set-phar-options':
#        path => '/usr/bin:/usr/sbin:/bin',
#        command => 'sed -i \'s/^[; ]*;phar.readonly *= *.*/phar.readonly = 0/g\' /etc/php5/cli/php.ini',
#        require => [Package['php5']]
#    }

#    exec { 'php-apache-realpath-cache-size':
#        path => '/usr/bin:/usr/sbin:/bin',
#        command => 'sed -i \'s/^[; ]*;realpath_cache_size *= *[0-9]+./realpath_cache_size = 8M/g\' /etc/php5/apache2/php.ini',
#        require => [Package['php5']]
#    }

    file_line { 'php-apache-realpath-cache-size':
        path  => '/etc/php5/apache2/php.ini',
        match => 'realpath_cache_size =',
        line  => 'realpath_cache_size = 8M',
        require => Package['php5'],
        notify  => Exec['php5:restart']
    }

    file_line { 'php-apache-realpath-cache-ttl':
        path  => '/etc/php5/apache2/php.ini',
        match => 'realpath_cache_ttl =',
        line  => 'realpath_cache_ttl = 7200',
        require => Package['php5'],
        notify  => Exec['php5:restart']
    }

#;realpath_cache_ttl = 120

#    exec { 'php-cli-disable-short-open-tag':
#        path => '/usr/bin:/usr/sbin:/bin',
#        command => 'sed -i \'s/^[; ]*short_open_tag =.*/short_open_tag = Off/g\' /etc/php5/cli/php.ini',
#        onlyif => 'test "`php -c /etc/php5/cli/php.ini -r \"echo ini_get(\'short_open_tag\');\"`" = "1"',
#        require => [Package['php5']]
#    }

}
