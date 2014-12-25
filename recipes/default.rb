#
# Cookbook Name:: atlassian
# Recipe:: default
#
# Copyright (c) 2014 The Authors, All Rights Reserved.


# Jira & Confluence installation requires Oracle JDK
node.default['java']['install_flavor'] = 'oracle'
node.default['java']['jdk_version'] = '7'
node.default['java']['oracle']['accept_oracle_download_terms'] = true
include_recipe 'java'

include_recipe "atlassian::jira"
include_recipe "atlassian::confluence"

