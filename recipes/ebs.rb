include_recipe "aws"

aws_ebs_volume "atlassian_data_volume" do
    action :attach
    volume_id node['atlassian']['aws']['volume_id']
    device node['atlassian']['aws']['target_device']
end

bash "format_data_volume" do
    user "root"
    code <<-EOH
        if [ "$(blkid -p #{node['atlassian']['aws']['target_device']} -s TYPE -o value)" != "#{node['atlassian']['aws']['target_fs']}" ]; then
            mkfs -t #{node['atlassian']['aws']['target_fs']} #{node['atlassian']['aws']['target_device']}
        fi
    EOH
end

directory node['atlassian']['home']['base'] do
    mode '0755'
end

mount node['atlassian']['home']['base'] do
    device node['atlassian']['aws']['target_device']
    fstype node['atlassian']['aws']['target_fs']
    action [:mount, :enable]
end
