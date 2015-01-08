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

dir_to_link ::File.join(node['atlassian']['jira']['jira_dir'], 'logs') do
    to node['atlassian']['jira']['log_dir']
end

put_mysql_connector node['atlassian']['jira']['mysql_connector_jar_path'] do
 service "runit_service[jira]"
end

template ::File.join(node['atlassian']['jira']['conf_dir'], 'server.xml') do
  source 'jira-server.xml.erb'
  mode '0644'
  notifies :restart, 'runit_service[jira]'
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

backup_atlassian "Jira" do
    home_dir node['atlassian']['jira']['home']

    db_name node['atlassian']['jira']['db']['name']
    db_user node['atlassian']['jira']['db']['username']
    db_pass node['atlassian']['jira']['db']['password']

    hour node['atlassian']['jira']['backup']['hour']
    minute node['atlassian']['jira']['backup']['minute']
end

runit_service "jira" do
    owner node['atlassian']['jira']['user']
    group node['atlassian']['jira']['group']
    options({
        user: node['atlassian']['jira']['user'],
        group: node['atlassian']['jira']['group'],
        java_opts: node['atlassian']['jira']['java_opts'],
        jira_home: node['atlassian']['jira']['home'],
        directory: node['atlassian']['jira']['jira_dir'],
        log_dir: node['atlassian']['jira']['log_dir'],
    })
end
