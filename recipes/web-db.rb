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

mysql_database 'update root user so it can connect from any host' do
  connection node['app']['mysql_connection_info']
  sql        "UPDATE mysql.user SET Host='%' WHERE Host='localhost'"
  action     :query
end
mysql_database 'delete remaining root users' do
  connection node['app']['mysql_connection_info']
  sql        "DELETE FROM mysql.user WHERE User='root' AND Host<>'%'"
  action     :query
end
mysql_database 'flush the privileges' do
  connection node['app']['mysql_connection_info']
  sql        'flush privileges'
  action     :query
end
