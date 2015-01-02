include_attribute "ark"
include_attribute "nginx"

default['nginx']['default_site_enabled'] = false
default['nginx']['pid'] = '/run/nginx.pid'

default['atlassian']['mysql_connector']['version'] = '5.1.34'
default['atlassian']['mysql_connector']['tgz_file'] = "mysql-connector-java-#{node['atlassian']['mysql_connector']['version']}.tar.gz"
default['atlassian']['mysql_connector']['url'] = "http://cdn.mysql.com/Downloads/Connector-J/#{node['atlassian']['mysql_connector']['tgz_file']}"
default['atlassian']['mysql_connector']['checksum'] = 'eb33f5e77bab05b6b27f709da3060302bf1d960fad5ddaaa68c199a72102cc5f'
default['atlassian']['mysql_connector']['jar_file'] = "mysql-connector-java-#{node['atlassian']['mysql_connector']['version']}-bin.jar"
default['atlassian']['mysql_connector']['jar_path_in_tgz'] = "mysql-connector-java-#{node['atlassian']['mysql_connector']['version']}/#{node['atlassian']['mysql_connector']['jar_file']}"
default['atlassian']['mysql_connector']['tgz_path'] = ::File.join(Chef::Config['file_cache_path'], node['atlassian']['mysql_connector']['tgz_file'])
default['atlassian']['mysql_connector']['jar_path'] = ::File.join(Chef::Config['file_cache_path'], node['atlassian']['mysql_connector']['jar_file'])

default['atlassian']['db']['server'] = 'dbserver'
default['atlassian']['db']['port'] = '3306'
default['atlassian']['db']['base_url'] = "jdbc:mysql://#{node['atlassian']['db']['server']}:#{node['atlassian']['db']['port']}"
default['atlassian']['db']['params'] = 'useUnicode=true&amp;characterEncoding=UTF8&amp;sessionVariables=storage_engine=InnoDB'

default['atlassian']['aws']['volume_id'] = ""
default['atlassian']['aws']['target_device'] = "/dev/xvdi"
default['atlassian']['aws']['target_fs'] = "ext4"

default['atlassian']['home']['base'] = "/srv"

# Confluence
default['atlassian']['confluence']['servername'] = 'confluence.mydomain.com'
default['atlassian']['confluence']['port'] = '8090'
default['atlassian']['confluence']['url'] = 'http://downloads.atlassian.com/software/confluence/downloads/atlassian-confluence-5.6.5.tar.gz'
default['atlassian']['confluence']['version'] = '5.6.5'
default['atlassian']['confluence']['checksum'] = '013b9fc8d20f5947637abefea1386532bb484134de57a70f7fd78d177352bd4d'
default['atlassian']['confluence']['group'] = 'confluence'
default['atlassian']['confluence']['user'] = 'confluence'
default['atlassian']['confluence']['home'] = ::File.join(node['atlassian']['home']['base'], 'confluence')
default['atlassian']['confluence']['confluence_dir'] = ::File.join(node['ark']['prefix_root'], 'confluence')
default['atlassian']['confluence']['log_dir'] = '/var/log/confluence'
default['atlassian']['confluence']['conf_dir'] = ::File.join(node['atlassian']['confluence']['confluence_dir'], 'conf')
default['atlassian']['confluence']['temp_dir'] = ::File.join(node['atlassian']['confluence']['confluence_dir'], 'temp')
default['atlassian']['confluence']['work_dir'] = ::File.join(node['atlassian']['confluence']['confluence_dir'], 'work')
default['atlassian']['confluence']['lib_dir'] = ::File.join(node['atlassian']['confluence']['confluence_dir'], 'confluence/WEB-INF/lib')
default['atlassian']['confluence']['confluence_init_path'] = ::File.join(default['atlassian']['confluence']['confluence_dir'], 'confluence/WEB-INF/classes/confluence-init.properties')
default['atlassian']['confluence']['mysql_connector_jar_path'] = ::File.join(node['atlassian']['confluence']['lib_dir'], node['atlassian']['mysql_connector']['jar_file'])

default['atlassian']['confluence']['db']['name'] = 'confluence'
default['atlassian']['confluence']['db']['username'] = 'confluenceuser'
default['atlassian']['confluence']['db']['password'] = 'confluencepass'

# Jira
default['atlassian']['jira']['servername'] = 'jira.mydomain.com'
default['atlassian']['jira']['port'] = '8080'
default['atlassian']['jira']['url'] = 'http://downloads.atlassian.com/software/jira/downloads/atlassian-jira-6.3.12.tar.gz'
default['atlassian']['jira']['version'] = '6.3.12'
default['atlassian']['jira']['checksum'] = 'e25469a801c6630e6bc5c04e7bb11086b9b3ef929cae5858f4035cdc1a0e1ad3'
default['atlassian']['jira']['group'] = 'jira'
default['atlassian']['jira']['user'] = 'jira'
default['atlassian']['jira']['home'] = ::File.join(node['atlassian']['home']['base'], 'jira')
default['atlassian']['jira']['log_dir'] = '/var/log/jira'
default['atlassian']['jira']['jira_dir'] = ::File.join(node['ark']['prefix_root'], 'jira')
default['atlassian']['jira']['conf_dir'] = ::File.join(node['atlassian']['jira']['jira_dir'], 'conf')
default['atlassian']['jira']['temp_dir'] = ::File.join(node['atlassian']['jira']['jira_dir'], 'temp')
default['atlassian']['jira']['work_dir'] = ::File.join(node['atlassian']['jira']['jira_dir'], 'work')
default['atlassian']['jira']['lib_dir'] = ::File.join(node['atlassian']['jira']['jira_dir'], 'lib')
default['atlassian']['jira']['mysql_connector_jar_path'] = ::File.join(node['atlassian']['jira']['lib_dir'], node['atlassian']['mysql_connector']['jar_file'])

default['atlassian']['jira']['db']['name'] = 'jiradb'
default['atlassian']['jira']['db']['username'] = 'jiradbuser'
default['atlassian']['jira']['db']['password'] = 'jirapassword'
default['atlassian']['jira']['db']['url'] = "#{node['atlassian']['db']['base_url']}/#{node['atlassian']['jira']['db']['name']}?#{node['atlassian']['db']['params']}"

# proxy settings
default['atlassian']['proxy']['external_ssl'] = false
