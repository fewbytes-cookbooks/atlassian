# Backup definition for an atlassian product
#   Create an archive containing:
#     * MySQL dump
#     * Home Directory (including data, attachments, etc.)
#   Upload the archive to S3
#
#   NOTE: Jira/Confluence manuals recommend to avoid the xml backups for large installations

define :backup_atlassian,   :db_name => nil, :db_user => nil, :db_pass => nil, :db_host => nil, 
                            :s3_keep_num => nil, :s3_region => nil, :s3_bucket => nil, :s3_path => nil,
                            :home_dir => nil, :minute => nil, :hour => nil do

    params[:db_host] = (params[:db_host] or node['atlassian']['db']['server'])
    params[:s3_keep_num] = (params[:s3_keep_num] or node['atlassian']['backup']['s3_keep_num'])
    params[:s3_region] = (params[:s3_region] or node['atlassian']['backup']['s3_region'])
    params[:s3_bucket] = (params[:s3_bucket] or node['atlassian']['backup']['s3_bucket'])
    params[:s3_path] = (params[:s3_path] or node['atlassian']['backup']['s3_path'])


    include_recipe "backup"

    backup_model params[:name] do

        description "Backup Atlassian application"

        definition <<-DEF
            archive "#{params[:name]}" do |archive|
                archive.add "#{params[:home_dir]}"
            end

            database MySQL do |db|
                db.name = "#{params[:db_name]}"
                db.username = "#{params[:db_user]}"
                db.password = "#{params[:db_pass]}"
                db.host = "#{params[:db_host]}"
            end

            compress_with Bzip2

            store_with S3 do |s3|
                s3.use_iam_profile = true

                s3.keep = #{params[:s3_keep_num]}
                
                s3.region = "#{params[:s3_region]}"
                s3.bucket = "#{params[:s3_bucket]}"
                s3.path = "#{params[:s3_path]}"
            end
        DEF

        schedule({
            :minute => params[:minute],
            :hour   => params[:hour]
        })
    end
end
