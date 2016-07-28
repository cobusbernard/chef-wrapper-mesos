name             'chef-wrapper-mesos'
maintainer       'Cobus Bernard'
maintainer_email 'me@cobus.io'
license          'MIT'
description      'Installs/Configures chef-wrapper-mesos'
long_description 'Installs/Configures chef-wrapper-mesos'
version          '0.1.54'

depends 'mesos', '~> 3.5.1'

depends 'zookeeper'
depends 'hostsfile', '~> 2.4.5'
