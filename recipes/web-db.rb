#
# MySQL server
#

# Do we have already MySQL installed?
mysql_installed = command?('mysqld_safe')

include_recipe "mysql::server" unless mysql_installed

# MySQL extra config
template "#{node['mysql']['server']['directories']['confd_dir']}/extra.cnf" do
  source 'mysql/extra.cnf.erb'
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
