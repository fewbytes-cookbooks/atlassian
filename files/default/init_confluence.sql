CREATE DATABASE confluence CHARACTER SET utf8 COLLATE utf8_bin;

GRANT ALL PRIVILEGES ON confluence.* TO 'confluenceuser'@'%' IDENTIFIED BY 'confluencepass';

flush privileges;
