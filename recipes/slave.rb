#
# Cookbook Name:: chef-wrapper-mesos
# Recipe:: server
#
# Copyright (C) 2016 Cobus Bernard
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

#hostsfile_entry '172.17.8.51' do
#  hostname  'server1.cobus.io server1'
#  action    [:create_if_missing, :update]
#end

#hostsfile_entry '172.17.8.52' do
#  hostname  'server2.cobus.io server2'
#  action    [:create_if_missing, :update]
#end

#hostsfile_entry '172.17.8.53' do
#  hostname  'server3.cobus.io server3'
#  action    [:create_if_missing, :update]
#end


instances = search(:node, "role:mesos-master AND chef_environment:#{node.chef_environment}")
instances.sort_by!{ |n| n[:fqdn] }

# No point in setting up if there aren't any master nodes in the cluster.
if instances.length > 0

  mesos_master = "zk://" + instances.map{|n| "#{n[:fqdn]}:2181" }.join(",") + "/mesos"

  node.set['mesos']['slave']['flags']['master'] = mesos_master
  node.set['mesos']['slave']['flags']['containerizers'] = 'docker,mesos'
  node.set['mesos']['slave']['flags']['executor_registration_timeout'] = '5mins'
  node.set['mesos']['slave']['flags']['ip'] = node[:network][:interfaces][:eth1][:addresses].detect{|k,v| v[:family] == "inet" }.first

  include_recipe 'mesos::slave'

  # Kubernetes demo specific
  directory '/etc/mesos-dns' do
    owner 'root'
    group 'root'
    mode '0755'
    action :create
  end

  template "/etc/mesos-dns/config.json" do
    source "mesos-dns-config.json.erb"
    variables( :zk_master => mesos_master, :dns_upstream => '8.8.8.8' )
  end
end
