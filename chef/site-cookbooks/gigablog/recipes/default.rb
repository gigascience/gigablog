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

bash 'Install GigaBlog' do
  cwd '/tmp'
  code <<-EOH
  	# Install WP CLI
  	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    sudo mv wp-cli.phar /usr/local/bin/wp
    sudo /usr/local/bin/wp core install --path=/var/www/wordpress --url=localhost:9170 --title=GigaBlog --admin_user=peter --admin_email=peter@gigasciencejournal.com --admin_password=gigadb --skip-email
    # Install WP WXR import plugin
    sudo /usr/local/bin/wp plugin install wordpress-importer --path=/var/www/wordpress
    sudo /usr/local/bin/wp plugin activate wordpress-importer --path=/var/www/wordpress
    sudo yum -y install php-xml
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
