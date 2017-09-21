# # encoding: utf-8

# Inspec test for recipe jvogt_tomcat::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe user('tomcat-test') do
  it { should exist }
  its('group') { should eq 'tomcat-test-group' }
end

describe group('tomcat-test-group') do
  it { should exist }
end

describe service('tomcat-default-test') do
  it { should be_enabled }
  it { should be_running }
end

describe port(8080) do
  it { should be_listening }
end

tomcat_install_dir = '/opt/tomcat-default-test'

describe directory("#{tomcat_install_dir}/conf") do
  it { should exist }
  its('group') { should eq 'tomcat-test-group' }
  its('mode') { should cmp '0775' }
end

describe file("#{tomcat_install_dir}/conf/server.xml") do
  its('group') { should eq 'tomcat-test-group' }
  its('mode') { should cmp '0640' }
end

describe directory("#{tomcat_install_dir}/webapps") do
  its('owner') { should eq 'tomcat-test' }
end

describe file("#{tomcat_install_dir}/webapps/ROOT") do
  its('owner') { should eq 'tomcat-test' }
end

describe directory("#{tomcat_install_dir}/work") do
  its('owner') { should eq 'tomcat-test' }
end

describe directory("#{tomcat_install_dir}/temp") do
  its('owner') { should eq 'tomcat-test' }
end

describe directory("#{tomcat_install_dir}/logs") do
  its('owner') { should eq 'tomcat-test' }
end
