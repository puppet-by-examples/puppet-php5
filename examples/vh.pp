# First: you have to install php
# include php5

class { 'apache':
    mpm_module    => prefork,
    user          => 'www-data',
    group         => 'www-data',
    default_vhost => false,
#    require       => Class['php5']
}

include ::apache::mod::rewrite

class { '::apache::mod::php':
    path => "${::apache::params::lib_path}/libphp5.so",
}


$list = [
  {
      'domain' => 'abc.example.net',
      'rootdir' => '/var/www/abc'
  },
  {
      'domain' => 'example.net',
      'rootdir' => '/var/www/main'
  },
  {
      'domain' => 'foo.bar.example.net',
      'rootdir' => '/var/www/foo-bar'
  },
]

php5::vhosts{ $list: }