# Make mysql connector jar available in the cache directory
remote_file node['atlassian']['mysql_connector']['tgz_path'] do
    source node['atlassian']['mysql_connector']['url']
    checksum node['atlassian']['mysql_connector']['checksum']
    mode '0644'
end

dest_dir = ::File.dirname(node['atlassian']['mysql_connector']['jar_path'])

bash 'extract_connector' do
    code <<-EOH
        tar --strip-components 1 -C #{dest_dir} -xzf #{node['atlassian']['mysql_connector']['tgz_path']} #{node['atlassian']['mysql_connector']['jar_path_in_tgz']}
        chmod 0644 #{node['atlassian']['mysql_connector']['jar_path']}
    EOH
    not_if { ::File.exists?(node['atlassian']['mysql_connector']['jar_path']) }
end
