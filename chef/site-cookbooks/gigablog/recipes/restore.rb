#
# Cookbook Name:: gigablog
# Recipe:: restore
#
# Copyright 2016, GigaScience
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'wordpress'

aws_access_key = node[:aws][:aws_access_key_id]
aws_secret_access_key = node[:aws][:aws_secret_access_key]
aws_default_region = node[:aws][:aws_default_region]

# Install AWS CLI
bash 'Install AWS CLI' do
    code <<-EOH
        curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "/tmp/awscli-bundle.zip" >> /vagrant/log/aws.log 2>&1
        sudo yum -y install unzip >> /vagrant/log/aws.log 2>&1
        sudo /usr/bin/unzip /tmp/awscli-bundle.zip -d /tmp >> /vagrant/log/aws.log 2>&1
        sudo /tmp/awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws >> /vagrant/log/aws.log 2>&1
        if [ -d /root/.aws ]
        then
            # Will enter here if .aws exists, even if it contains spaces
            echo ".aws folder exists"
        else
            mkdir -p /root/.aws
        fi
    EOH
end

template "/root/.aws/credentials" do
    source 'aws_credentials.erb'
    mode '0644'
    ignore_failure true
    action :create_if_missing
end

template "root/.aws/config" do
    source 'aws_config.erb'
    mode '0644'
    ignore_failure true
    action :create_if_missing
end

##########################################################################
### Fix CSS problem with not updating when using vagrant with local VM ###
##########################################################################
gigablog_box = node[:gigablog_box]
if gigablog_box != "aws"
	bash 'Fix CSS Vagrant problem' do
		code <<-EOH
			sudo sed -i '1 i\EnableSendfile off' /etc/httpd/conf/httpd.conf
		EOH
	end
end

#########################################################
### Install WordPress CLI and import GigaBlog content ###
#########################################################

site_url = node[:gigablog][:url]
wordpress_dir = node[:wordpress][:dir]
vagrant_dir = node[:gigablog][:vagrant_dir]

root_password = node[:wordpress][:db][:root_password]
user_password = node[:wordpress][:db][:password]

wp_theme = node[:gigablog][:theme]

elastic_ip = node[:aws][:aws_elastic_ip]
# Escape dots in elastic IP address
esc_elastic_ip = elastic_ip.gsub! '.', '\.'

bash 'Restore GigaBlog' do
  cwd '/tmp'
  code <<-EOH
  	# Install WP CLI
  	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    sudo mv wp-cli.phar /usr/local/bin/wp
    sudo /usr/local/bin/wp core install --path=#{wordpress_dir} --url=#{site_url} --title=GigaBlog --admin_user=#{node[:gigablog][:admin]} --admin_email=#{node[:gigablog][:admin_email]} --admin_password=#{node[:gigablog][:admin_password]} --skip-email
    # Install WP WXR import plugin
    sudo /usr/local/bin/wp plugin install wordpress-importer --path=#{wordpress_dir}
    sudo /usr/local/bin/wp plugin activate wordpress-importer --path=#{wordpress_dir}
    # Enable XML parsing
    sudo yum -y install php-xml
    # Enable image cropping
    sudo yum -y install gd gd-devel php-gd

    # Restore mysql database using sql file in /tmp
    /usr/local/bin/aws s3 cp s3://gigablog-backups/#{node[:gigablog][:sqlS3filename]} /tmp/database.sql >> #{vagrant_dir}/log/aws.log 2>&1
    mysqldump -u root --password=#{root_password} --no-data #{node[:wordpress][:db][:name]} | grep ^DROP > /tmp/drop.sql
    mysql -u root --password=#{root_password}  #{node[:wordpress][:db][:name]} < /tmp/drop.sql
    rm /tmp/drop.txt
    # Replace all urls in sql file with value of the site_url variable
    sed -i.bak s_#{esc_elastic_ip}_#{site_url}_g /tmp/database.sql
    mysql -u root --password=#{root_password} wordpressdb < /tmp/database.sql

    # Restore WP directory
    /usr/local/bin/aws s3 cp s3://gigablog-backups/#{node[:gigablog][:wpS3filename]}  /tmp/gigablog_wp.tar.gz >> #{vagrant_dir}/log/aws.log 2>&1
    tar -xvzf /tmp/gigablog_wp.tar.gz -C /tmp
    sudo rm -fr #{wordpress_dir}
    sudo mv /tmp/var/www/wordpress /var/www

    # Set wordpressuser mysql password
	/usr/bin/mysql -u root --password=#{root_password} --execute "SET PASSWORD FOR 'wordpressuser'@'localhost' = PASSWORD('#{user_password}');"
	/usr/bin/mysql -u root --password=#{root_password} --execute "FLUSH PRIVILEGES;"

	# Update wp-config.php
	sed -i "/DB_PASSWORD/s/'[^']*'/'#{user_password}'/2" #{wordpress_dir}/wp-config.php

	# uploads dir needs to be writable by apache to allow edits
 	sudo chown -R apache:apache #{wordpress_dir}/wp-content/uploads/*

 	# Update users
	sudo /usr/local/bin/wp user update --path=#{wordpress_dir} #{node[:gigablog][:user1_email]}  --user_url=#{node[:gigablog][:user1_url]} --description='#{node[:gigablog][:user1_description]}'
	sudo /usr/local/bin/wp user update --path=#{wordpress_dir} #{node[:gigablog][:user2_email]}  --description='#{node[:gigablog][:user2_description]}'
 	EOH
end

# Make theme dir readable by apache
theme_dir = "/vagrant/theme"
directory theme_dir do
  group 'apache'
  mode '0755'
  action :create
end

# Create link to theme in /vagrant directory
link '/var/www/wordpress/wp-content/themes/gigasci' do
  to '/vagrant/theme/gigasci'
end

# Provide new apache conf file for GigaBlog and gigascience redirect
template "/etc/httpd/sites-available/wordpress.conf" do
    source 'wordpress.conf.erb'
    mode '0644'
end


##################
#### Template ####
##################

template "/vagrant/theme/gigasci/header.php" do
    source 'header.php.erb'
    mode '0644'
    ignore_failure true
    owner 'apache'
    group 'apache'
    action :create
end


###########################################
#### Set up automated database backups ####
###########################################

aws_access_key = node[:aws][:aws_access_key_id]
aws_secret_access_key = node[:aws][:aws_secret_access_key]
aws_default_region = node[:aws][:aws_default_region]

# Install AWS CLI
bash 'Install AWS CLI' do
    code <<-EOH
        curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "/tmp/awscli-bundle.zip" >> /vagrant/log/aws.log 2>&1
        sudo yum -y install unzip >> /vagrant/log/aws.log 2>&1
        sudo /usr/bin/unzip /tmp/awscli-bundle.zip -d /tmp >> /vagrant/log/aws.log 2>&1
        sudo /tmp/awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws >> /vagrant/log/aws.log 2>&1
        if [ -d /root/.aws ]
        then
            # Will enter here if .aws exists, even if it contains spaces
            echo ".aws folder exists"
        else
            mkdir -p /root/.aws
        fi
    EOH
end

template "/root/.aws/credentials" do
    source 'aws_credentials.erb'
    mode '0644'
    ignore_failure true
    action :create_if_missing
end

template "root/.aws/config" do
    source 'aws_config.erb'
    mode '0644'
    ignore_failure true
    action :create_if_missing
end

directory '/vagrant/scripts' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

template "/vagrant/scripts/db_backup.sh" do
    source 'db_backup.sh.erb'
    mode '0644'
end

bash 'make db_backup.sh executable' do
    code <<-EOH
        chown root:gigablog-admin #{vagrant_dir}/scripts/db_backup.sh
        chmod ugo+x #{vagrant_dir}/scripts/db_backup.sh
    EOH
end

cron 'WordPress backup cron job' do
    minute '59'
    hour '23'
    day '*'
    month '*'
    weekday '7'
    shell '/bin/bash'
    path '/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin'
    user 'root'
    command '/vagrant/scripts/db_backup.sh /var/www/wordpress'
end

bash 'restart cron service' do
    code <<-EOH
        service crond restart
    EOH
end