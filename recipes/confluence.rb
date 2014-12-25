#
# Cookbook Name:: atlassian
# Recipe:: confluence
#
# Copyright (c) 2014 The Authors, All Rights Reserved.

include_recipe 'apt'
include_recipe 'runit'

group node['atlassian']['confluence']['group'] do
    system true
end

user node['atlassian']['confluence']['user'] do
    home node['atlassian']['confluence']['home']
    gid node['atlassian']['confluence']['group']
    system true
end

ark 'confluence' do
    url node['atlassian']['confluence']['url']
    version node['atlassian']['confluence']['version']
    checksum node['atlassian']['confluence']['checksum']
end

%w(log_dir home temp_dir work_dir conf_dir).each do |dir|
    directory node['atlassian']['confluence'][dir] do
        mode "0755"
        owner node['atlassian']['confluence']['user']
        group node['atlassian']['confluence']['group']
    end
end

template node['atlassian']['confluence']['confluence_init_path'] do
    mode '0644'
    owner node['atlassian']['confluence']['user']
    group node['atlassian']['confluence']['group']
    variables({
        confluence_home: node['atlassian']['confluence']['home'],
    })
   notifies :restart, "runit_service[confluence]"
end

dir_to_link ::File.join(node['atlassian']['confluence']['confluence_dir'], 'logs') do
    to node['atlassian']['confluence']['log_dir']
end

put_mysql_connector node['atlassian']['confluence']['mysql_connector_jar_path'] do
 service "runit_service[confluence]"
end

#TODO: template confluence.cfg.xml in convluence's home (license and mysql configuration)

runit_service "confluence" do
    owner node['atlassian']['confluence']['user']
    group node['atlassian']['confluence']['group']
    options({
        user: node['atlassian']['confluence']['user'],
        group: node['atlassian']['confluence']['group'],
        directory: node['atlassian']['confluence']['confluence_dir'],
        log_dir: node['atlassian']['confluence']['log_dir'],
    })
end

