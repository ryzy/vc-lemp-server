#
# MySQL server
#

# Do we have already MySQL installed?
mysql_installed = command?('mysqld_safe')

include_recipe 'mysql::client'
include_recipe 'mysql::server'
include_recipe 'database::mysql' # so mysql_database* works in other cookbooks

# Make sure MySQL log dir exists (otherwise MySQL cannot start)
directory node['mysql']['log_dir'] do
  owner 'mysql'
  mode 00755
end

# MySQL extra tuning
template '/etc/mysql/conf.d/tuning.cnf' do
  source 'mysql/tuning.cnf.erb'
  owner 'mysql'
  owner 'mysql'
  notifies :restart, 'mysql_service[default]'
end

# Put .my.cnf for root user, so it can use mysql tool w/o providing credentials
template "/root/.my.cnf" do
  source 'mysql/user-my.cnf.erb'
  variables({ :user => 'root', :pass => node['mysql']['server_root_password'] })
  mode 0600
end

# Alter root user so it can access database from anywhere
# MySQL should be behind firewall anyway, so users who can bypass firewall should be able to login.
execute "alter root user(s)" do
  command "mysql --execute=\"
    UPDATE mysql.user SET Host='%' WHERE User='root' AND Host='localhost';
    DELETE FROM mysql.user WHERE User='root' AND Host<>'%';
    FLUSH PRIVILEGES;
  \""
end unless mysql_installed # only run it after initial MySQL installation
