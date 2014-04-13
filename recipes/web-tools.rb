# composer packages to install globally for node['app']['user'] user
node['system']['composer_global_install'].each do |pkg|
  execute "composer global require #{pkg}" do
    cwd "#{node[:system][:www_root]}"
    user node['app']['user']
    environment (node['system']['composer_env'])
  end
end
