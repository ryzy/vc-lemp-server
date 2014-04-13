include_recipe 'ruby_build'

node['chruby']['rubies'].each do |rv, install|
  next if !install
  ruby_build_ruby rv
end

chruby_installed = command?('chruby-exec')
include_recipe 'chruby' unless chruby_installed

# Fix: In some cases chruby sets also GEM_HOME, which affects chef's ruby.
# Make sure that variable is not set (as it's not essential for the rest of the system).
chruby_sh_file = File.join(node['chruby']['sh_dir'], node['chruby']['sh_name'])
execute "echo 'unset GEM_HOME' >> #{chruby_sh_file}" do
  not_if "grep 'unset GEM_HOME' #{chruby_sh_file}"
end


# .gemrc
file '/etc/gemrc' do
  content 'gem: --no-rdoc --no-ri'
  owner   'root'
  group   'root'
  mode    '0644'
end unless chruby_installed # don't override file content during consequent provisioning

# Update to the latest RubyGems version
execute "#{node['system']['gem_binary']} update --system" do
  not_if "#{node['system']['gem_binary']} list | grep -q rubygems-update"
end

gem_package 'bundler' do
  gem_binary node['system']['gem_binary']
end
