#
# sudo puppet apply /etc/puppet/modules/php5/examples/default.pp
# sudo puppet apply -e 'include php5'
#

php5::generate_ssl_cert { 'some.special.example.lh':
    domain => 'some.special.example.lh'
}