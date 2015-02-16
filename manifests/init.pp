# == Class: php5
#
# Class to install php5 from ppa:ondrej/php5.
#
# Parameters:
#
# None
#

class php5 {

    # validate_platform() function comes from
    # puppet module gajdaw/diverse_functions
    #
    #     https://forge.puppetlabs.com/gajdaw/diverse_functions
    #
    if !validate_platform($module_name) {
        fail("Platform not supported in module '${module_name}'.")
    }

    Exec { path => [
        '/usr/local/sbin',
        '/usr/local/bin',
        '/usr/sbin',
        '/usr/bin',
        '/sbin',
        '/bin'
    ]}

    class { 'php5::prerequisites': }

    exec { 'php5:update-php-add-repository':
        command => 'add-apt-repository ppa:ondrej/php5',
        require => Class['php5::prerequisites']
    }

    exec { 'php5:apt-get-update':
        command => 'apt-get update -y',
        require => Exec['php5:update-php-add-repository']
    }

    package { 'php5':
        ensure  => installed,
        require => Exec['php5:apt-get-update']
    }

    package { 'php5-curl':
        ensure  => installed,
        require => Package['php5']
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

    file_line { 'php5_apache2_short_open_tag':
        path    => '/etc/php5/apache2/php.ini',
        match   => 'short_open_tag =',
        line    => 'short_open_tag = Off',
        require => Package['php5'],
    }

    file_line { 'php5_cli_short_open_tag':
        path    => '/etc/php5/cli/php.ini',
        match   => 'short_open_tag =',
        line    => 'short_open_tag = Off',
        require => Package['php5'],
    }

    file_line { 'php5_apache2_date_timezone':
        path    => '/etc/php5/apache2/php.ini',
        match   => 'date.timezone =',
        line    => 'date.timezone = Europe/Warsaw',
        require => Package['php5'],
    }

    file_line { 'php5_cli_date_timezone':
        path    => '/etc/php5/cli/php.ini',
        match   => 'date.timezone =',
        line    => 'date.timezone = Europe/Warsaw',
        require => Package['php5'],
    }

    file_line { 'php-apache-realpath-cache-size':
        path    => '/etc/php5/apache2/php.ini',
        match   => 'realpath_cache_size =',
        line    => 'realpath_cache_size = 8M',
        require => Package['php5'],
    }

    file_line { 'php-apache-realpath-cache-ttl':
        path    => '/etc/php5/apache2/php.ini',
        match   => 'realpath_cache_ttl =',
        line    => 'realpath_cache_ttl = 7200',
        require => Package['php5'],
    }

    file_line { 'php-cli-phar-readonly':
        path    => '/etc/php5/cli/php.ini',
        match   => ';phar.readonly = On',
        line    => 'phar.readonly = Off',
        require => Package['php5'],
    }

}
