override['mesos']['version'] = '0.28.2'
override['mesos']['master']['flags']['cluster'] = 'mesos-home'
override['mesos']['master']['flags']['work_dir'] = "/opt/mesos-master/work_dir"
override['mesos']['slave']['flags']['work_dir'] = "/opt/mesos-slave/work_dir"
