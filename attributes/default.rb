#
# Cookbook:: jvogt_tomcat
# Attributes:: default
#

default['jvogt_tomcat']['user'] = 'tomcat'
default['jvogt_tomcat']['group'] = 'tomcat'
default['jvogt_tomcat']['java']['package_name'] = 'java-1.7.0-openjdk-devel'
default['jvogt_tomcat']['install_path'] = '/opt/tomcat'
default['jvogt_tomcat']['tomcat_binary']['uri'] = 'https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.33/bin/apache-tomcat-8.0.33.tar.gz'
default['jvogt_tomcat']['tomcat_binary']['checksum'] = 'c77873c1861ed81617abb8bedc392fb0ff5ebf871de33cd1fcd49d4c072e38b7'
default['jvogt_tomcat']['java_home'] = '/usr/lib/jvm/jre'
