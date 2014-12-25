# Extract MySQL Connector to given destination (full path), and notifies service to restart
define :extract_mysql_connector, :service => nil do
    remote_file node['atlassian']['mysql_connector']['tgz_path'] do
        source node['atlassian']['mysql_connector']['url']
        checksum node['atlassian']['mysql_connector']['checksum']
        mode '0644'
    end

    dest_dir = ::File.dirname(params[:name])

    bash 'extract_mysql_connector' do
        code <<-EOH
            tar --strip-components 1 -C #{dest_dir} -xzf #{node['atlassian']['mysql_connector']['tgz_path']} #{node['atlassian']['mysql_connector']['jar_path_in_tgz']}
            chmod 0644 #{params[:name]}
        EOH
        not_if { ::File.exists?(params[:name]) }
        unless params[:service].nil?
            notifies :restart, params[:service]
        end
    end
end
