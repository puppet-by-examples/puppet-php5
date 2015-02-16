# == Class: php5::prerequisites
#
# Ensure any required dependencies for php5 are present.
#
# Parameters:
#
# None
#

class php5::prerequisites {

    include stdlib

    if (
        ($::operatingsystem == 'Ubuntu') and
        ($::operatingsystemrelease == '14.04')
    ) {

        $deps = [
            'software-properties-common',
            'curl',
            'libcurl3',
            'libcurl3-dev',
            'acl'
        ]

    } elsif (
        ($::operatingsystem == 'Ubuntu') and
        ($::operatingsystemrelease == '12.04')
    ) {

        $deps = [
            'python-software-properties',
            'curl',
            'libcurl3',
            'libcurl3-dev',
            'acl'
        ]

    }

    ensure_packages($deps)

}
