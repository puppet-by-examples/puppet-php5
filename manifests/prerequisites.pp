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
            'software-properties-common'
        ]

    } elsif (
        ($::operatingsystem == 'Ubuntu') and
        ($::operatingsystemrelease == '12.04')
    ) {

        $deps = [
            'python-software-properties'
        ]

    }

    ensure_packages($deps)

    $common_deps = [
        'curl',
        'libcurl3',
        'libcurl3-dev',
        'acl'
    ]

    ensure_packages($common_deps)

}
