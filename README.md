# jvogt_tomcat

Chef Tomcat Workshop cookbook

See: https://github.com/chef-training/workshops/tree/master/Tomcat

## Resources

### jvogt\_tomcat

Manages tomcat package & service install

#### Actions

- `:create` - install tomcat

#### Attribute Parameters

- `instance_name` - Used as a suffix on install directory, service name.  Defaults to resource block's name if not specified
- `run_user` - User service runs as.  Will be created if missing. Defaults to `'tomcat'`
- `run_group` - Group service user is member of.  Will be created if missing. Defaults to `'tomcat'`
- `install_path` - Path to install tomcat to. Defaults to `'/opt/tomcat-#{instance_name}'`
- `java_package` - Yum package for java, defaults to `'java-1.7.0-openjdk-devel'`
- `tomcat_binary_uri` - URI to tomcat binary tgz, defaults to `''https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.33/bin/apache-tomcat-8.0.33.tar.gz''`
- `tomcat_binary_checksum` - Checksum of above tgz, defaults to actual checksum of above.

#### Examples

```ruby
# Installs tomcat into /opt/tomcat-default with all defaults
jvogt_tomcat 'default'

# Installs tomcat with custom user & group
jvogt_tomcat 'default' do
  run_user 'someuser'
  run_group 'somegroup'
end
```
