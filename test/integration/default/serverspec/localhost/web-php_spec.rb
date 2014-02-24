require 'serverspec'

describe "::web-php tests" do
  WWW_USER  = 'www'
  WWW_UID   = 80
  WWW_GROUP = 'www'
  WWW_GID   = 80
  
  describe service('php-fpm') do
    it { should be_running }
  end
  describe process('php-fpm') do
    it { should be_running }
  end
  describe file('/var/run/php-fpm-www.sock') do
    it { should be_socket }
  end
  
  # Check if php upsteram config exist in nginx
  describe file('/etc/nginx/conf.d/upstream_php.conf') do
    it { should be_file }
  end
  
  # Make sure can start/restart with no errors
  describe command('/etc/init.d/php-fpm restart') do
    it { should return_exit_status 0 }
  end
  
  describe 'PHP.ini params' do
    context php_config('display_errors') do
      its(:value) { should eq 'On' }
    end
    context php_config('display_startup_errors') do
      its(:value) { should eq 'On' }
    end
    context php_config('opcache.enable') do
      its(:value) { should eq 1 }
    end
    context php_config('date.timezone') do
      its(:value) { should match /Europe/ }
    end
  end
  
  describe command("curl localhost") do
    its(:stdout) { should match /phpMyAdmin/ }
    its(:stdout) { should match /phpinfo\(\)/ }
  end
  
  # test pear packages
  ['phpunit','composer'].each do |cmd|
    describe command("which #{cmd}") do
      it { should return_exit_status 0 }
    end
  end
end
