#
# Cookbook:: jvogt_tomcat
# Recipe:: default
#

group node['jvogt_tomcat']['group']

user node['jvogt_tomcat']['user'] do
  group node['jvogt_tomcat']['group']
end

package node['jvogt_tomcat']['java']['package_name']

directory node['jvogt_tomcat']['install_path'] do
  action :create
  recursive true
end

