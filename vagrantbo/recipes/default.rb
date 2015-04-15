#
# Cookbook Name:: vagrantbo
# Recipe:: default
#
# Copyright 2015, Craycode
#
# All rights reserved - Do Not Redistribute
#

apache_site 'default' do
	enable true
end

package "nfs-common" do
	action :install
end

package "php5-memcached" do
  action :install
end

package "memcached" do
	action :install
end

service "memcached" do
	action [:enable, :start]
end

package "php5-mysql" do
	action :install
end

package "php5-curl" do
	action :install
end

package "php5-intl" do
	action :install
end

package "php5-ldap" do
	action :install
end

package "php5-mcrypt" do
	action :install
end

package "php5-curl" do
	action :install
end

package "php5-sqlite" do
	action :install
end

package "php5-xdebug" do
	action :install
end

template "/etc/php5/apache2/php.ini" do
  source 'php.ini.erb'
  owner 'root'
  group node['apache']['root_group']
  mode '0644'
  notifies :restart, 'service[apache2]', :delayed
end

template "/etc/php5/cli/php.ini" do
  source 'php.ini.erb'
  owner 'root'
  group node['apache']['root_group']
  mode '0644'
  notifies :restart, 'service[apache2]', :delayed
end

cert = ssl_certificate 'bo1.5' do
  namespace node['bo1.5']
  notifies :restart, 'service[apache2]'
end

web_app "bo1.5" do
	template 'bo1.5.conf.erb'
	ssl_key cert.key_path
	ssl_cert cert.cert_path
	server_name 'tickets.sadlerswells.site'
	server_aliases ['tickets.royalalberthall.site', 'tickets.jw3.site']
	docroot '/var/www/bo1.5/web'
end