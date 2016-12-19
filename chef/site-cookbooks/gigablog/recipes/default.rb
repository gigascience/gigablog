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

admin = node[:gigablog][:admin]
admin_name = node[:gigablog][:admin_name]
admin_email = node[:gigablog][:admin_email]
admin_password = node[:gigablog][:admin_password]
admin_role = node[:gigablog][:admin_role]
user1 = node[:gigablog][:user1]
user1_name = node[:gigablog][:user1_name]
user1_email = node[:gigablog][:user1_email]
user1_password = node[:gigablog][:user1_password]
user1_role = node[:gigablog][:user1_role]
user2 = node[:gigablog][:user2]
user2_name =  node[:gigablog][:user2_name]
user2_email = node[:gigablog][:user2_email]
user2_password = node[:gigablog][:user1_password]
user2_role = node[:gigablog][:user2_role]
user3 = node[:gigablog][:user3]
user3_name = node[:gigablog][:user3_name]
user3_email = node[:gigablog][:user3_email]
user3_password = node[:gigablog][:user3_password]
user4_role = node[:gigablog][:user4_role]
user4 = node[:gigablog][:user4]
user4_name = node[:gigablog][:user4_name]
user4_email = node[:gigablog][:user4_email]
user4_password = node[:gigablog][:user4_password]
user5_role = node[:gigablog][:user5_role]

bash 'Install GigaBlog' do
  cwd '/tmp'
  code <<-EOH
  	# Install WP CLI
  	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    sudo mv wp-cli.phar /usr/local/bin/wp
    sudo /usr/local/bin/wp core install --path=#{wordpress_dir} --url=#{site_url} --title=GigaBlog --admin_user=peter --admin_email=peter@gigasciencejournal.com --admin_password=gigadb --skip-email
    # Install WP WXR import plugin
    sudo /usr/local/bin/wp plugin install wordpress-importer --path=#{wordpress_dir}
    sudo /usr/local/bin/wp plugin activate wordpress-importer --path=#{wordpress_dir}
    # Enable XML parsing
    sudo yum -y install php-xml
    # Enable image cropping
    sudo yum -y install gd gd-devel php-gd
    # Create users
    sudo /usr/local/bin/wp user create --path=#{wordpress_dir} #{admin} #{admin_email} --role=#{admin_role}
	sudo /usr/local/bin/wp user create --path=#{wordpress_dir} #{user1} #{user1_email} --role=#{user1_role}
	sudo /usr/local/bin/wp user create --path=#{wordpress_dir} #{user2} #{user2_email} --role=#{user2_role}
	sudo /usr/local/bin/wp user create --path=#{wordpress_dir} #{user3} #{user3_email} --role=#{user3_role}
	sudo /usr/local/bin/wp user create --path=#{wordpress_dir} #{user4} #{user4_email} --role=#{user4_role}
    # Import blog content
    sudo /usr/local/bin/wp import --path=#{wordpress_dir} #{wxr_path} --authors=create
    # Clean up
    sudo /usr/local/bin/wp post delete --path=#{wordpress_dir} 1
    # Configure site
    sudo /usr/local/bin/wp option update blogdescription 'Data driven blogging from the GigaScience Editors' --path=#{wordpress_dir}
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