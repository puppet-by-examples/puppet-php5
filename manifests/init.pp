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
        command => 'add-apt-repository ppa:ondrej/php',
        require => Class['php5::prerequisites']
    }

    exec { 'php5:apt-get-update':
        command => 'apt-get update -y',
        require => Exec['php5:update-php-add-repository']
    }

    package { 'php5.6':
        ensure  => installed,
        require => Exec['php5:apt-get-update']
    }

    package { 'php5.6-curl':
        ensure  => installed,
        require => Package['php5.6']
    }

    package { 'php5.6-xdebug':
        ensure  => installed,
        require => Package['php5.6']
    }

    package { 'php5.6-xsl':
        ensure  => installed,
        require => Package['php5.6']
    }

    package { 'php5.6-mysql':
        ensure  => installed,
        require => Package['php5.6']
    }

    package { 'php5.6-pgsql':
        ensure  => installed,
        require => Package['php5.6']
    }

    package { 'php5.6-xml':
        ensure  => installed,
        require => Package['php5.6']
    }

}
