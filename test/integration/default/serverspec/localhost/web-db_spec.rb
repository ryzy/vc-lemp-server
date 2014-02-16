require 'serverspec'

describe "web-db recipe" do
  
  # MySQL is up & running
  describe service('mysqld') do
    it { should be_enabled }
  end
  describe process('mysqld_safe') do
    it { should be_running }
  end
  describe port(3306) do
    it { should be_listening.with('tcp') }
  end
  
  # /root/.my.cnf
  describe file('/root/.my.cnf') do
    it { should be_file }
    it { should contain 'user=root' }
  end
  
  # Check if 'root' user can access db from any host
  describe command("mysql -sN --execute=\"select User,Host from mysql.user WHERE User='root'\"") do
    it { should return_exit_status 0 }
    its(:stdout) { should match /root\s+%/ }
  end
end
