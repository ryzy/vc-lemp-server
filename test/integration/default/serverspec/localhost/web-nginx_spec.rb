require 'serverspec'

describe "::web-nginx tests" do
  WWW_USER  = 'www'
  WWW_UID   = 80
  WWW_GROUP = 'www'
  WWW_GID   = 80
  
  # Test if www:www user/group is created, has proper uid/gid
  describe group(WWW_GROUP) do
    it { should exist }
    it { should have_gid WWW_GID }
  end
  describe user(WWW_USER) do
    it { should exist }
    it { should have_uid WWW_UID }
    it { should belong_to_group WWW_GROUP }
  end
  
  describe service('nginx') do
    it { should be_running }
  end
  describe process('nginx') do
    it { should be_running }
  end
  describe port(80) do
    it { should be_listening.with('tcp') }
  end
  
  # Make sure nginx can start/restart with no errors
  describe command('/etc/init.d/nginx restart') do
    it { should return_exit_status 0 }
    its(:stdout) { should match /Starting nginx.+?OK/ }
  end
  
  
  describe file('/var/www') do
    it { should be_directory }
    it { should be_owned_by WWW_USER }
    it { should be_grouped_into WWW_GROUP }
    it { should be_mode 775 }
  end
  
  # check default vhost index file
  describe file('/var/www/default/index.php') do
    it { should be_file }
    it { should be_owned_by WWW_USER }
    it { should be_grouped_into WWW_GROUP }
  end
  
  # check nginx logs permissions
  describe file('/var/log/nginx/error.log') do
    it { should be_file }
    it { should be_owned_by WWW_USER }
    it { should be_grouped_into WWW_GROUP }
    it { should be_mode 644 }
  end
end
