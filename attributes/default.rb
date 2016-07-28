override['mesos']['version'] = '1.0.0'
override['mesos']['master']['flags']['cluster'] = 'mesos-home'
override['mesos']['master']['flags']['work_dir'] = "/opt/mesos-master/work_dir"
override['mesos']['slave']['flags']['work_dir'] = "/opt/mesos-slave/work_dir"
