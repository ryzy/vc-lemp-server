#
# Install PHP
#
include_recipe 'php'

node[:system][:php_packages].each do |pkg|
  package pkg
end

node[:system][:pear_channels].each do |pear_channel|
  php_pear_channel pear_channel do
    action :discover
  end
end
node[:system][:pear_packages].each do |pkg|
  php_pear pkg.name do
    channel pkg.channel
    action :install
  end
end


#
# PHP-FPM
#
include_recipe 'php-fpm'

# Make sure /var/lib/php (where PHP stores sessions by default) has correct ownership
execute "chown -R #{node[:app][:user]}:#{node[:app][:group]} /var/lib/php* /var/log/php*"

# Extra config(s)
%w{ zz-opcache-overrides.ini zz-overrides.ini }.each do |conf|
  template "#{node['php']['ext_conf_dir']}/#{conf}" do
    source "php/#{conf}.erb"
    notifies :reload, 'service[php-fpm]'
  end
end

# Nginx: override default fastcgi_params with more tuned version
template "#{node[:nginx][:dir]}/fastcgi_params" do
  source 'nginx/fastcgi_params'
  owner  'root'
  group  'root'
  mode   '0644'
  notifies :reload, 'service[nginx]'
end

# Nginx: define upstream php which can be used in vhost configurations
template "#{node['nginx']['dir']}/conf.d/upstream_php.conf" do
  source 'nginx/upstream_php.conf.erb'
  owner  'root'
  group  'root'
  mode   '0644'
  notifies :reload, 'service[nginx]'
end



#
# PHP Composer
#
include_recipe 'composer'

# make sure composer which is installed globally by default is executable for 'www' user (composer recipe doesn't do that)
execute "chmod -v ugo+rx #{node['composer']['install_dir']}/composer*"

# make sure COMPOSER_HOME directory exist
directory node[:system][:composer_home] do
  owner node[:app][:user]
  group node[:app][:group]
  mode 00775
  recursive true
end


#
# Install phpMyAdmin
#
package 'phpMyAdmin'

link '/var/www/default/phpMyAdmin' do
 to '/usr/share/phpMyAdmin' # this is where package phpMyAdmin is installed by default
 owner node[:app][:user]
 group node[:app][:group]
end

# Install OPCache GUI
execute "composer create-project --dev --no-interaction --no-progress peehaa/opcachegui" do
  cwd "#{node[:system][:www_root]}/default"
  user node['app']['user']
  group node['app']['group']
  environment (node['system']['composer_env'])
  not_if "test -d #{node[:system][:www_root]}/default/opcachegui"
end

#
# Fix folders ownership/rights so /var/www is owned/writable by www-data:www-data
#
execute "chown -R #{node[:app][:user]}:#{node[:app][:group]} #{node[:system][:www_root]}"
execute "chmod -R ug+rw #{node[:system][:www_root]}"
# Permission fix: make ssh pubkey authentication working for 'www' user
execute "chmod -R go-rw #{node[:system][:www_root]}/.ssh"
execute "chmod go-w #{node[:system][:www_root]}"
