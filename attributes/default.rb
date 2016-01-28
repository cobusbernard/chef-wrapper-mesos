default_attributes(
  :mesos => {
    :version => '0.25.0',
    :master => {
      :flags => {
        :cluster => 'mesos-home',
        :zk => 'zk://127.0.0.1:2181/mesos'
      }
    }
  }
)
