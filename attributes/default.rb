# System: extra packages to install initially
default[:system][:packages] = ['vim','man','git','mc','htop','links','npm']
# Root directory for www data
default[:system][:www_root] = '/var/www'

# PHP: user/group
default['app']['group'] = 'www'
default['app']['user'] = 'www'
# PHP-FPM sock path - see cookbook php-fpm/templates/default/pool.conf.erb
default['app']['php_socket'] = '/var/run/php-fpm-www.sock'
# MySQL host name
default['app']['mysql_host'] = '127.0.0.1'


#
# MySQL settings
#
default['mysql']['server_root_password'] = 'password'
default['mysql']['server_repl_password'] = node['mysql']['server_root_password']
default['mysql']['server_debian_password'] = node['mysql']['server_root_password']

# MySQL tuning
default['mysql']['remove_anonymous_users']          = true
default['mysql']['remove_test_database']            = true
default['mysql']['bind_address']                    = '0.0.0.0'
default['mysql']['tunable']['character-set-server'] = 'utf8'
default['mysql']['tunable']['collation-server']     = 'utf8_unicode_ci'
default['mysql']['tunable']['max_connections']      = '50'
default['mysql']['tunable']['max_allowed_packet']   = '32M'
default['mysql']['tunable']['log_error']                    = '/var/log/mysql/error.log'
default['mysql']['tunable']['log_warnings']                 = 2
default['mysql']['tunable']['log_queries_not_using_index']  = true
default['mysql']['tunable']['open-files-limit']     = '16384'
default['mysql']['tunable']['query_cache_size']     = '128M'
default['mysql']['tunable']['thread_cache_size']    = 16
default['mysql']['tunable']['table_cache']          = '2048'
default['mysql']['tunable']['table_open_cache']     = node['mysql']['tunable']['table_cache']
default['mysql']['tunable']['sort_buffer_size']     = '2M'
default['mysql']['tunable']['read_buffer_size']     = '1M'
default['mysql']['tunable']['read_rnd_buffer_size'] = '8M'
default['mysql']['tunable']['join_buffer_size']     = '1M'
default['mysql']['tunable']['tmp_table_size']       = '64M'
default['mysql']['tunable']['max_heap_table_size']  = node['mysql']['tunable']['tmp_table_size']

# MySQL connection info to use with 'mysql' recipe
default['app']['mysql_connection_info'] = {
  :username => 'root',
  :password => node['mysql']['server_root_password'],
  :host     => node['app']['mysql_host']
}


#
# PHP settings
#
# PHP: extra packages/modules to install
default['system']['php_packages'] = ['php-opcache','php-pecl-gmagick']
# PEAR channels to add/discover
default['system']['pear_channels'] = ['pear.php.net','pecl.php.net']
default['system']['pear_packages'] = [
  # eg: { name:'PHPUnit', channel:'pear.phpunit.de' }
]

# COMPOSER_HOME set when executing composer
default['system']['composer_home'] = "#{node[:system][:www_root]}/.composer"
# COMPOSER_PROCESS_TIMEOUT: sometimes it takes a while, so make it longer then def. 300
default['system']['composer_timeout'] = '900' # Passed to env variables and must be string - otherwise Chef/Ruby triggers error
default['system']['composer_env'] = {
  # We set COMPOSER_HOME env before each composer run to fix the problem with
  # 'The "/root/.composer/cache/files/" directory does not exist'.
  'COMPOSER_HOME'             => node['system']['composer_home'],
  'COMPOSER_PROCESS_TIMEOUT'  => node['system']['composer_timeout']
}
# These will be installed via "composer global require 'some/package=version.x'" (for www user)
default['system']['composer_global_install'] = [
  'phpunit/phpunit=4.0.*',
  'phing/phing=dev-master',
]

# PHP tuning
default['php']['fpm_user']      = node[:app][:user]
default['php']['fpm_group']     = node[:app][:group]
default['php']['directives'] = { # extra directives added to the end of php.ini
  'memory_limit' => '256M',
  'display_errors' => 'On',
  'display_startup_errors' => 'On',
  'post_max_size' => '99M',
  'upload_max_filesize' => '99M',
  'date.timezone' => 'Europe/London',
}
# PHP-FPM settings + pools
default['php-fpm']['user'] = node['php']['fpm_user']
default['php-fpm']['group'] = node['php']['fpm_group']
default['php-fpm']['pools'] = [
  {
    :name => 'www',
    :user => node['php-fpm']['user'],
    :group => node['php-fpm']['group'],
    :max_children => 10,
    :start_servers => 2,
    :min_spare_servers => 2,
    :max_spare_servers => 5,
    :catch_workers_output => 'yes',
    :php_options => {
#      'php_admin_flag[log_errors]' => 'on', 
#      'php_admin_value[memory_limit]' => '32M' 
    }
  }
]



#
# Nginx settings
#
default['nginx']['user']                  = node[:app][:user]
default['nginx']['group']                 = node[:app][:group]
default['nginx']['default_site_enabled']  = false
default['nginx']['worker_processes']      = 2
default['nginx']['realip']['addresses']   = ['0.0.0.0/32']
default['nginx']['client_max_body_size'] = '99M'


#
# Chruby, ruby_build
#
default['chruby']['version'] = '0.3.8'
default['chruby']['rubies'] = {
  '2.0.0-p451' => true,
}
default['chruby']['default'] = '2.0.0-p451'

default['ruby_build']['default_ruby_base_path'] = '/opt/rubies'

# shortcut: default gem binary to use while using gem_package
default['system']['gem_binary'] = "#{node['ruby_build']['default_ruby_base_path']}/#{node['chruby']['default']}/bin/gem"
