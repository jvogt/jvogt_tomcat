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

tomcat_package_download_location = File.join(Chef::Config[:file_cache_path], File.basename(node['jvogt_tomcat']['tomcat_binary']['uri']))

remote_file tomcat_package_download_location do
  source node['jvogt_tomcat']['tomcat_binary']['uri']
  checksum node['jvogt_tomcat']['tomcat_binary']['checksum']
  notifies :run, 'execute[Unpack Tomcat Binary]', :immediately
end

execute 'Unpack Tomcat Binary' do
  command "tar xvf #{tomcat_package_download_location} -C #{node['jvogt_tomcat']['install_path']} --strip-components=1"
  action :nothing
end

directory File.join(node['jvogt_tomcat']['install_path'], 'conf') do
  group node['jvogt_tomcat']['group'] # TODO: write execute to idempotently chgrp on contents
  mode '0755'
end

%w(webapps work temp logs).each do |d|
  directory File.join(node['jvogt_tomcat']['install_path'], d) do
    user node['jvogt_tomcat']['user'] # TODO: write execute to idempotently chgrp on contents
  end
end

template '/etc/systemd/system/tomcat.service'

service 'tomcat' do
  action [:start, :enable]
end
