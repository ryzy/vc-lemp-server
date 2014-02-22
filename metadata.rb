name             'lemp-server'
maintainer       'Marcin Ryzycki'
maintainer_email 'marcin@ryzycki.com'
license          'GPL 2'
description      'Chef cookbook for making universal PHP/Nginx/MySQL server'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.3.0'

depends 'yum'             # https://github.com/opscode-cookbooks/yum
depends 'ruby_build', '~> 0.8.0'  # https://github.com/fnichol/chef-ruby_build
depends 'chruby',     '~> 0.2.2'  # https://github.com/Atalanta/chef-chruby
depends 'swap'            # https://github.com/sethvargo-cookbooks/swap
depends 'mysql'           # https://github.com/opscode-cookbooks/mysql
depends 'database'        # https://github.com/opscode-cookbooks/database
depends 'nginx'           # https://github.com/opscode-cookbooks/nginx
depends 'php', '~> 1.2.0' # https://github.com/opscode-cookbooks/php
depends 'php-fpm'         # https://github.com/yevgenko/cookbook-php-fpm
depends 'composer'        # https://github.com/escapestudios/chef-composer
depends 'logrotate'       # https://github.com/stevendanna/logrotate
