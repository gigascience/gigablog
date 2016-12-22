#
# Cookbook Name:: gigablog
# Recipe:: default
#
# Copyright 2016, GigaScience
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'wordpress'

['vim', 'tree'].each do |pkg|
    package pkg
end

# iptables not required for default development environment
service 'iptables' do
    action [:disable, :stop]
end

#########################################################
### Install WordPress CLI and import GigaBlog content ###
#########################################################

site_url = node[:gigablog][:url]
wordpress_dir = node[:wordpress][:dir]
vagrant_dir = node[:gigablog][:root_dir]
wxr_file = node[:gigablog][:wxr_file]
wxr_path = "#{vagrant_dir}/wxr/#{wxr_file}"

root_password = node[:wordpress][:db][:root_password]
user_password = node[:wordpress][:db][:password]
wp_theme = node[:gigablog][:theme]

bash 'Install GigaBlog' do
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
    # Create users
	sudo /usr/local/bin/wp user create --path=#{wordpress_dir} #{node[:gigablog][:user1]} #{node[:gigablog][:user1_email]} --role=#{node[:gigablog][:user1_role]} --user_pass=#{node[:gigablog][:user1_password]} --display_name=#{node[:gigablog][:user1_name]}
	sudo /usr/local/bin/wp user create --path=#{wordpress_dir} #{node[:gigablog][:user2]} #{node[:gigablog][:user2_email]} --role=#{node[:gigablog][:user2_role]} --user_pass=#{node[:gigablog][:user2_password]} --display_name=#{node[:gigablog][:user2_name]}
	sudo /usr/local/bin/wp user create --path=#{wordpress_dir} #{node[:gigablog][:user3]} #{node[:gigablog][:user3_email]} --role=#{node[:gigablog][:user3_role]} --user_pass=#{node[:gigablog][:user3_password]} --display_name=#{node[:gigablog][:user3_name]}
	sudo /usr/local/bin/wp user create --path=#{wordpress_dir} #{node[:gigablog][:user4]} #{node[:gigablog][:user4_email]} --role=#{node[:gigablog][:user4_role]} --user_pass=#{node[:gigablog][:user4_password]} --display_name=#{node[:gigablog][:user4_name]}
    # Import blog content
    sudo /usr/local/bin/wp import --path=#{wordpress_dir} #{wxr_path} --authors=create
    # Clean up
    sudo /usr/local/bin/wp post delete --path=#{wordpress_dir} 1
    # Configure site
    sudo /usr/local/bin/wp option update blogdescription 'Data driven blogging from the GigaScience Editors' --path=#{wordpress_dir}
    # Add link to sparkling theme
    sudo ln -s /vagrant/theme/#{wp_theme} /var/www/wordpress/wp-content/themes/#{wp_theme}
    # Activate theme
    sudo /usr/local/bin/wp theme --path=#{wordpress_dir} activate #{wp_theme}

    # Set wordpressuser mysql password
    /usr/bin/mysql -u root --password=#{root_password} --execute "SET PASSWORD FOR 'wordpressuser'@'localhost' = PASSWORD('#{user_password}');"
	/usr/bin/mysql -u root --password=#{root_password} --execute "FLUSH PRIVILEGES;"

    # Update wp-config.php
	sed -i "/DB_PASSWORD/s/'[^']*'/'#{user_password}'/2" /var/www/wordpress/wp-config.php
    EOH
end

# uploads dir needs to be writable by apache to allow edits
uploads_dir = "/var/www/wordpress/wp-content/uploads"
directory uploads_dir do
  owner 'apache'
  group 'apache'
  mode '0755'
  action :create
end

# Make theme dir readable by apache
theme_dir = "/vagrant/theme"
directory theme_dir do
  group 'apache'
  mode '0755'
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

template "#{vagrant_dir}/scripts/db_backup.sh" do
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
    shell '/bin/bash'
    path '/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin'
    user 'root'
    command '/vagrant/scripts/db_backup.sh'
end

bash 'restart cron service' do
    code <<-EOH
        service crond restart
    EOH
end