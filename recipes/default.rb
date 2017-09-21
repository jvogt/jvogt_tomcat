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

  notifies :run, 'execute[Permissions Update]', :immediately
end

# Note: I tried the fileutils cookbook to manage permissions of directory contents, however it was not idempotent.
# Issue here: https://github.com/Nordstrom/fileutils-cookbook/issues/3
#
# Probably best to use a tool like compliance anyway, instead of changing some arbitrary set of files

execute 'Permissions Update' do
  action :nothing
  cwd node['jvogt_tomcat']['install_path']
  command <<-EOF
    chgrp -R #{node['jvogt_tomcat']['group']} conf
    chmod g+rwx conf
    chmod g+r conf/*
    chown -R #{node['jvogt_tomcat']['user']} webapps/ work/ temp/ logs/
    EOF
end

template '/etc/systemd/system/tomcat.service'

service 'tomcat' do
  action [:start, :enable]
end
