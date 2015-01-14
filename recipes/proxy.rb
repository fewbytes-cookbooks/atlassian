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

file ::File.join(node['nginx']['dir'], 'conf.d', 'cache.conf') do
  content <<-EOF
proxy_cache_path /var/cache/nginx keys_zone=static:60m levels=2 max_size=200m;
EOF
  mode "0644"
  notifies :restart, "service[nginx]"
end

nginx_site 'jira' do
    enable true
end
nginx_site 'confluence' do
    enable true
end
