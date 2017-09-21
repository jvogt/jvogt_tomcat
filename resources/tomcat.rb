#
# Cookbook:: jvogt_tomcat
# Resource:: jvogt_tomcat
#

resource_name :jvogt_tomcat
provides :jvogt_tomcat

property :instance_name, name_property: true

property :run_user,               String,  default: 'tomcat'
property :run_group,              String,  default: 'tomcat'
property :install_path,           String,  default: lazy { ::File.join('/opt', "tomcat-#{instance_name}") }
property :java_package,           String,  default: 'java-1.7.0-openjdk-devel'
property :tomcat_binary_uri,      String,  default: 'https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.33/bin/apache-tomcat-8.0.33.tar.gz'
property :tomcat_binary_checksum, String,  default: 'c77873c1861ed81617abb8bedc392fb0ff5ebf871de33cd1fcd49d4c072e38b7'

default_action :install

action :install do
  group new_resource.run_group

  user new_resource.run_user do
    group new_resource.run_group
  end

  package new_resource.java_package

  directory new_resource.install_path do
    action :create
    recursive true
  end

  tomcat_package_download_location = ::File.join(Chef::Config[:file_cache_path], ::File.basename(new_resource.tomcat_binary_uri))

  remote_file tomcat_package_download_location do
    source new_resource.tomcat_binary_uri
    checksum new_resource.tomcat_binary_checksum
  end

  # leave a breadcrumb if extraction was successful.  This is slightly more resilient than relying on a notify to succeed in one chef run.
  breadcrumb_path = ::File.join(new_resource.install_path,".tomcat_unpacked_checksum-#{new_resource.tomcat_binary_checksum}")

  bash "Unpack Tomcat Binary to #{tomcat_package_download_location}" do
    code <<-EOH
      tar xvf "#{tomcat_package_download_location}" -C "#{new_resource.install_path}" --strip-components=1
      touch "#{breadcrumb_path}"
    EOH
    not_if { ::File.exist?(breadcrumb_path) }
    notifies :run, "execute[Permissions Update for #{new_resource.install_path}]", :immediately
  end

  # Note: I tried the fileutils cookbook to manage permissions of directory contents, however it was not idempotent.
  # Issue here: https://github.com/Nordstrom/fileutils-cookbook/issues/3
  #
  # Probably best to use a tool like compliance anyway, instead of changing some arbitrary set of files

  execute "Permissions Update for #{new_resource.install_path}" do
    action :nothing
    cwd new_resource.install_path
    command <<-EOF
      chgrp -R #{new_resource.run_group} conf
      chmod g+rwx conf
      chmod g+r conf/*
      chown -R #{new_resource.run_user} webapps/ work/ temp/ logs/
      EOF
  end

  template "/etc/systemd/system/tomcat-#{new_resource.instance_name}.service" do
    source 'tomcat.service.erb'
    cookbook 'jvogt_tomcat'
    variables({
      install_path: new_resource.install_path,
      run_user: new_resource.run_user,
      run_group: new_resource.run_group,
      java_home: node['jvogt_tomcat']['java_home']
      })
  end

  service "tomcat-#{new_resource.instance_name}" do
    action [:start, :enable]
  end
end