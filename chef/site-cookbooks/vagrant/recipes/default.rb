#
# Cookbook Name:: vagrant
# Recipe:: default
#
# Copyright 2012, Cogini
#
# All rights reserved - Do Not Redistribute
#

case node[:gigablog][:deployment]
when 'restore'
    include_recipe "gigablog::restore"

    log 'message' do
        message 'Restoring GigaBLOG WordPress website'
        level :info
    end
when 'deploy'
    include_recipe "gigablog"

    log 'message' do
        message 'Deploying GigaBLOG WordPress website'
        level :info
    end
end

['vim', 'tree'].each do |pkg|
    package pkg
end

# iptables not required for default development environment
service 'iptables' do
    action [:disable, :stop]
end
