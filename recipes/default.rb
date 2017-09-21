#
# Cookbook:: jvogt_tomcat
# Recipe:: default
#

jvogt_tomcat 'default' do
  run_user node['jvogt_tomcat']['user']
  run_group node['jvogt_tomcat']['group']
  install_path node['jvogt_tomcat']['install_path']
  java_package node['jvogt_tomcat']['java']['package_name']
  tomcat_binary_uri node['jvogt_tomcat']['tomcat_binary']['uri']
  tomcat_binary_checksum node['jvogt_tomcat']['tomcat_binary']['checksum']
end
