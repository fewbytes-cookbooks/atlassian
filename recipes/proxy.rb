include_recipe 'nginx'

template "#{node['nginx']['dir']}/sites-available/jira" do
    source 'atlassian-site.erb'
    owner  'root'
    group  node['root_group']
    mode   '0644'
    notifies :reload, 'service[nginx]'
    variables({
        servername: node["atlassian"]["jira"]["servername"],
        port: node["atlassian"]["jira"]["port"]
    })
end

template "#{node['nginx']['dir']}/sites-available/confluence" do
    source 'atlassian-site.erb'
    owner  'root'
    group  node['root_group']
    mode   '0644'
    notifies :reload, 'service[nginx]'
    variables({
        servername: node["atlassian"]["confluence"]["servername"],
        port: node["atlassian"]["confluence"]["port"]
    })
end

nginx_site 'jira' do
    enable true
end
nginx_site 'confluence' do
    enable true
end

