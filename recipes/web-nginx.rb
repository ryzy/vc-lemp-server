# Create www group
group node[:app][:group] do
  gid 80
end
# Create www user
user node[:app][:user] do
  uid 80
  gid 80
  system true
  home '/var/www'
  shell '/bin/bash'
  supports :manage_home=>false
end

# Vagrant user: :manage action will only do sth if the user is present
user 'vagrant' do
  gid 80
  action :manage
end
group node[:app][:group] do
  action :manage
  append true
  members 'vagrant'
  only_if 'id -u vagrant &>/dev/null'
end


# /var/www - make sure it exists and has correct permissions
directory node[:system][:www_root] do
  owner node[:app][:user]
  group node[:app][:group]
  mode 00755
  recursive true
end
directory "#{node[:system][:www_root]}/.ssh" do
  owner node[:app][:user]
  group node[:app][:group]
  mode 00700
end


#
# Nginx
#
include_recipe 'nginx'
include_recipe 'nginx::http_realip_module'
include_recipe 'nginx::http_gzip_static_module'
include_recipe 'nginx::http_spdy_module'

# prepare generic configs to include inside vhost configurations
%w{ common security static }.each do |conf|
  template "#{node['nginx']['dir']}/include-#{conf}.conf" do
    source "nginx/include-#{conf}.conf.erb"
    notifies :reload, 'service[nginx]'
  end
end

# configure default vhost in /var/www/default
directory "#{node[:system][:www_root]}/default" do
  owner node[:app][:user]
  group node[:app][:group]
  mode 00775
  recursive true
end

# disable default.conf from nginx/conf.d/default.conf
nginx_default_vhost = "#{node['nginx']['dir']}/conf.d/default.conf"
nginx_default_vhost_disabled = "#{node['nginx']['dir']}/conf.d/default.conf.disabled"
execute "disable_nginx_default.conf_vhost" do
  command "mv #{nginx_default_vhost} #{nginx_default_vhost_disabled}"
  user 'root'
  creates nginx_default_vhost_disabled
  notifies :reload, 'service[nginx]'
end

# vhost default
template "#{node['nginx']['dir']}/sites-available/default" do
  source 'nginx/site-default.erb'
  cookbook 'lemp-server'
  notifies :reload, 'service[nginx]'
end
nginx_site 'default' do
  enable true
  notifies :reload, 'service[nginx]', :immediately
end

# Put there index.php file
template "#{node[:system][:www_root]}/default/index.php" do
  source "index.php.erb"
  mode   00775
  owner node[:app][:user]
  group node[:app][:group]
end

# Override logrotate so it has correct permissions and rotates every week only
logrotate_app 'nginx' do
  cookbook  'logrotate'
  path      '/var/log/nginx/*.log'
  frequency 'weekly'
  rotate    12
  create    "644 #{node[:app][:user]} #{node[:app][:group]}"
  postrotate "[ -f /var/run/nginx.pid ] && kill -USR1 `cat /var/run/nginx.pid`"
  sharedscripts true
end
execute "chown -R #{node['app']['user']}:#{node['app']['group']} /var/log/nginx; chmod 644 /var/log/nginx/*"
