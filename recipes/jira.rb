#
# Cookbook Name:: atlassian
# Recipe:: jira
#
# Copyright (c) 2014 The Authors, All Rights Reserved.

include_recipe 'apt'
include_recipe 'runit'

group node['atlassian']['jira']['group'] do
    system true
end

user node['atlassian']['jira']['user'] do
    home node['atlassian']['jira']['home']
    gid node['atlassian']['jira']['group']
    system true
end

ark 'jira' do
    url node['atlassian']['jira']['url']
    version node['atlassian']['jira']['version']
    checksum node['atlassian']['jira']['checksum']
    # "Do not make the JIRA Installation Directory itself writeable by the dedicated user account"
end

%w(log_dir home temp_dir work_dir conf_dir).each do |dir|
    directory node['atlassian']['jira'][dir] do
        mode "0755"
        owner node['atlassian']['jira']['user']
        group node['atlassian']['jira']['group']
    end
end


# Move logging from local dir (to /var/log)
jira_local_logs = ::File.join(node['atlassian']['jira']['jira_dir'], 'logs')

directory jira_local_logs do
    action :delete
    only_if {not ::File.symlink?(jira_local_logs) and ::File.directory?(jira_local_logs)}
end

link jira_local_logs do
    to node['atlassian']['jira']['log_dir']
end

extract_mysql_connector node['atlassian']['jira']['mysql_connector_jar_path'] do
 service "runit_service[jira]"
end

template ::File.join(node['atlassian']['jira']['home'], 'dbconfig.xml') do
    mode '0644'
    owner node['atlassian']['jira']['user']
    group node['atlassian']['jira']['group']
    variables({
        url: node['atlassian']['jira']['db']['url'],
        user: node['atlassian']['jira']['db']['username'],
        password: node['atlassian']['jira']['db']['password'],
    })
   notifies :restart, "runit_service[jira]"
end

runit_service "jira" do
    owner node['atlassian']['jira']['user']
    group node['atlassian']['jira']['group']
    options({
        user: node['atlassian']['jira']['user'],
        group: node['atlassian']['jira']['group'],
        jira_home: node['atlassian']['jira']['home'],
        directory: node['atlassian']['jira']['jira_dir'],
        log_dir: node['atlassian']['jira']['log_dir'],
    })
end

