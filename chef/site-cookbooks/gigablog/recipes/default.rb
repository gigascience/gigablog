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

#############################
### Install WordPress CLI ###
#############################

bash 'install wp-cli' do
  cwd '/tmp'
  code <<-EOH
  	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    sudo mv wp-cli.phar /usr/local/bin/wp
    EOH
end
