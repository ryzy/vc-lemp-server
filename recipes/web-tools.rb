rvm_installed = command?('rvm')
log "RVM already installed? #{rvm_installed}"

# Install RVM and configured Ruby version
include_recipe 'rvm' # must be included, so other RWRPs (e.g. rvm_gem) work correctly
include_recipe 'rvm::system' unless rvm_installed

# fix so Vagrant's chef-solo works correctly after installing RVM
include_recipe 'rvm::vagrant' unless rvm_installed
execute 'mv -f /usr/local/bin/chef* /usr/bin/.' do
  only_if 'test -f /usr/local/bin/chef-solo'
end

#
# Install common gems
#
rvm_gem 'sass' do
  version     '3.3.0.rc.2'
end

rvm_gem 'compass' do
  version     '1.0.0.alpha.17'
end
