CREATE DATABASE jiradb CHARACTER SET utf8 COLLATE utf8_bin;

GRANT ALL PRIVILEGES ON jiradb.* TO 'jiradbuser'@'%' IDENTIFIED BY 'jirapassword';

flush privileges;
