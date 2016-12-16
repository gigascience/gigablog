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
bash 'Install GigaBlog' do
  cwd '/tmp'
  code <<-EOH
  	# Install WP CLI
  	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    sudo mv wp-cli.phar /usr/local/bin/wp
    sudo /usr/local/bin/wp core install --path=/var/www/wordpress --url=#{site_url} --title=GigaBlog --admin_user=peter --admin_email=peter@gigasciencejournal.com --admin_password=gigadb --skip-email
    # Install WP WXR import plugin
    sudo /usr/local/bin/wp plugin install wordpress-importer --path=/var/www/wordpress
    sudo /usr/local/bin/wp plugin activate wordpress-importer --path=/var/www/wordpress
    # Enable XML parsing
    sudo yum -y install php-xml
    # Enable image cropping
    sudo yum -y install gd gd-devel php-gd
    # Create users
	sudo /usr/local/bin/wp user create --path=/var/www/wordpress scott peter@gigasciencejournal.com --role=author
	sudo /usr/local/bin/wp user create --path=/var/www/wordpress nicole peter@gigasciencejournal.com --role=author
	sudo /usr/local/bin/wp user create --path=/var/www/wordpress hans peter@gigasciencejournal.com --role=author
	sudo /usr/local/bin/wp user create --path=/var/www/wordpress laurie peter@gigasciencejournal.com --role=author
    # Import blog content
    sudo /usr/local/bin/wp import --path=/var/www/wordpress /vagrant/wxr/test.gigablog.wordpress.xml --authors=create
    # Clean up
    sudo /usr/local/bin/wp post delete --path=/var/www/wordpress 1
    # Configure site
    sudo /usr/local/bin/wp option update blogdescription 'Data driven blogging from the GigaScience Editors' --path=/var/www/wordpress
    # Add link to sparkling theme
    sudo ln -s /vagrant/theme/sparkling /var/www/wordpress/wp-content/themes/sparkling
    # Activate sparkling theme
    sudo /usr/local/bin/wp theme --path=/var/www/wordpress activate sparkling
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