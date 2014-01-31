#
# MySQL server
#
include_recipe "mysql::server"

# MySQL extra config
template "#{node['mysql']['server']['directories']['confd_dir']}/extra.cnf" do
  source 'mysql-extra.cnf.erb'
end


#
# MySQL databases
#
include_recipe "database::mysql"

# define mysql connection parameters
mysql_connection_info = {
  :host     => '127.0.0.1',
  :username => 'root',
  :password => node['mysql']['server_root_password']
}

mysql_database 'update root user so it can connect from any host' do
  connection mysql_connection_info
  sql        "UPDATE mysql.user SET Host='%' WHERE Host='localhost'"
  action     :query
end
mysql_database 'delete remaining root users' do
  connection mysql_connection_info
  sql        "DELETE FROM mysql.user WHERE User='root' AND Host<>'%'"
  action     :query
end

mysql_database 'flush the privileges' do
  connection mysql_connection_info
  sql        'flush privileges'
  action     :query
end
