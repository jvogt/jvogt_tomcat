#
# Cookbook:: jvogt_tomcat
# Recipe:: default
#

group node['jvogt_tomcat']['group']

user node['jvogt_tomcat']['user'] do
  group node['jvogt_tomcat']['group']
end

