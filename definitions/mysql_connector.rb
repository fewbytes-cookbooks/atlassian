# Copy MySQL Connector to a given destination (full path), and notifies service to restart
define :put_mysql_connector, :service => nil do
    include_recipe "atlassian::mysql_connector"

    remote_file params[:name] do 
        source ::File.join("file://", node['atlassian']['mysql_connector']['jar_path'])

        notifies :restart, params[:service] unless params[:service]
    end
end
