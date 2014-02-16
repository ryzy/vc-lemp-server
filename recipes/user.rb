# user 'vagrant' belongs to 'www' group - make sure it creates files
# which are also writable to 'www' group
execute "echo 'umask 002' > /home/vagrant/.bashrc" do
  only_if "test -d /home/vagrant"
end  

# Make files created by 'www' user also writable by its group members
execute "echo 'umask 002' > #{node[:system][:www_root]}/.bashrc" do
  only_if "test -d #{node[:system][:www_root]}"
end


# PS settings
template "/etc/profile.d/ps.sh" do
  source 'user/profile_ps.erb'
end
