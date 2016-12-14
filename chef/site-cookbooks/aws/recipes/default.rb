#
# Cookbook Name:: aws
# Recipe:: default
#
# Copyright 2016, GigaScience
#

include_recipe 'user'
include_recipe 'iptables'
include_recipe 'fail2ban'
include_recipe 'selinux'
include_recipe 'cron'

# Locates GigaDB in /vagrant directory
site_dir = node[:gigadb][:site_dir]

############################
#### Configure iptables ####
############################

service "iptables" do
    action :start
end

iptables_rule 'prefix'
iptables_rule 'http'
iptables_rule 'ssh'
iptables_rule 'postfix'

############################
#### Configure fail2ban ####
############################

# Protect against DDoS attacks
file "/etc/fail2ban/jail.local" do
    content <<-EOS
[ssh-ddos]

enabled  = true
port     = ssh
filter   = sshd-ddos
logpath  = /var/log/secure
maxretry = 6
    EOS
    owner "root"
    group "root"
    mode 0644
    notifies :restart, "service[fail2ban]"
end

###########################
#### Configure SELinux ####
###########################

selinux_state 'permissive' do
    action :permissive
end

# Add SELinux policies for GigaBlog
bash 'gigadb-admin group permissions' do
    code <<-EOH
        semanage fcontext -a -t httpd_sys_rw_content_t "/vagrant/log(/.*)?"
        restorecon -Rv "/vagrant/log"

        semanage fcontext -a -t httpd_sys_rw_content_t "/vagrant/theme(/.*)?"
                restorecon -Rv "/vagrant/theme"

        setsebool -P httpd_can_network_connect 1
        setsebool -P httpd_can_network_connect_db 1
    EOH
end

#selinux_state 'enforcing' do
#    action :enforcing
#end

##############################
#### User and group admin ####
##############################

# Create user accounts
user = node[:gigablog][:user]
user_name = node[:gigablog][:user_name]
user_public_key = node[:gigablog][:user_public_key]

user_account node[:gigablog][:user] do
    comment   node[:gigablog][:user_name]
    ssh_keys  node[:gigablog][:user_public_key]
    home      "/home/#{node[:gigablog][:user]}"
end

# Create group for GigaDB admins
group 'gigablog-admin' do
  action    :create
  members   [user]
  append    true
end

group 'wheel' do
    action  :modify
    members [user]
    append  true
end

#########################
#### Directory admin ####
#########################

# These folders are auto-created by Vagrant. If not using Vagrant e.g.
# when using Chef-Solo for provisioning, these folders are explicitly
# created.
dirs = %w{
  log
}

dirs.each do |component|
    the_dir = "/vagrant/#{component}"

    bash 'setup permissions' do
        code <<-EOH
        	# Check if directory exists
            if [ -d #{the_dir} ]
            then
                # Will enter here if the_dir exists,
                echo "#{the_dir} directory exists"
                chmod -R ugo+rwx #{the_dir}
            else
                mkdir -p #{the_dir}
                # chown -R nginx:gigablog-admin #{the_dir}
                chmod -R ugo+rwx #{the_dir}
            fi
        EOH
    end
end

# Change files in /vagrant to gigablog-admin group
bash 'gigablog-admin group permissions' do
    code <<-EOH
        chgrp -R gigablog-admin /vagrant/*
    EOH
end


#######################
#### Configure SSH ####
#######################

# Disable root logins and password authentication
bash 'Configure SSH' do
    code <<-EOH
        sed -i -- 's/#PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
        sed -i -- 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
    EOH
end


##########################
#### Install GigaBlog ####
##########################

include_recipe 'gigablog'


###########################################
#### Set up automated database backups ####
###########################################

aws_access_key = node[:aws][:aws_access_key_id]
aws_secret_access_key = node[:aws][:aws_secret_access_key]
aws_default_region = node[:aws][:aws_default_region]

# Install AWS CLI
bash 'Install AWS CLI' do
    code <<-EOH
        curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
        unzip awscli-bundle.zip
        sudo ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
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

template "#{site_dir}/scripts/db_backup.sh" do
    source 'db_backup.sh.erb'
    mode '0644'
end

bash 'make db_backup.sh executable' do
    code <<-EOH
        chown centos:gigablog-admin #{site_dir}/scripts/db_backup.sh
        chmod ugo+x #{site_dir}/scripts/db_backup.sh
    EOH
end

cron 'database backup cron job' do
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