include_recipe 'ruby_build'

node['chruby']['rubies'].each do |rv, install|
  next if !install
  ruby_build_ruby rv
end

include_recipe 'chruby'

# .gemrc
file '/etc/gemrc' do
  content 'gem: --no-rdoc --no-ri'
  owner   'root'
  group   'root'
  mode    '0644'
end

# Update to the latest RubyGems version
execute "#{node['system']['gem_binary']} update --system" do
  not_if "#{node['system']['gem_binary']} list | grep -q rubygems-update"
end

gem_package 'bundler' do
  gem_binary node['system']['gem_binary']
end
