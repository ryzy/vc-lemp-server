# PS settings
template "/etc/profile.d/ps.sh" do
  source 'user/profile_ps.erb'
end

# user 'vagrant' belongs to 'www' group - make sure it creates files
# which are also writable to 'www' group
execute "echo 'umask 002' >> /home/vagrant/.bash_profile" do
  only_if "id -u vagrant &>/dev/null"
  not_if "grep 'umask' /home/vagrant/.bash_profile"
end

# Default umask for www user
bash_profile = "#{node[:system][:www_root]}/.bash_profile"
execute "echo 'umask 002' >> #{bash_profile}" do
  not_if "grep 'umask 002' #{bash_profile}"
end
# Add composer vendor path to PATH
execute "echo 'PATH=~/.composer/vendor/bin:$PATH' >> #{bash_profile}" do
  not_if "grep 'PATH=~/.composer/vendor/bin' #{bash_profile}"
end
