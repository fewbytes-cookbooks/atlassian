# Replace empty directory with a link
# :name - empty dir to replace with link
# :to - link target
define :dir_to_link, :to => nil do
    raise 'you must specify link target' unless params[:to]

    directory params[:name] do
        action :delete
        only_if {not ::File.symlink?(params[:name]) and ::File.directory?(params[:name])}
    end

    link params[:name] do
        to params[:to]
    end
end

