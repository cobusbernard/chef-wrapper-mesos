#
# Cookbook Name:: chef-wrapper-mesos
# Recipe:: server
#
# Copyright (C) 2016 Cobus Bernard
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# 'Software'), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

bag = data_bag_item('config', 'zookeeper')[node.chef_environment]
node.default['zookeeper-cluster']['config']['instance_name'] = node['ipaddress']
node.default['zookeeper-cluster']['config']['ensemble'] = bag['ensemble']
include_recipe 'zookeeper-cluster::default'

instances = search(:node, 'role:mesos-master AND chef_environment:#{node.chef_environment}')
instances.sort_by! { |n| n[:ipaddress] }
node.set['mesos']['master']['flags']['zk'] = 'zk://' + instances.map{ |n| '#{n[:ipaddress]}:2181' }.join(',') + '/mesos'

node.set['mesos']['master']['flags']['quorum'] = [instances.length / 2, 1].max

include_recipe 'mesos::master'
