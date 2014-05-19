name             'lemp-server'
maintainer       'Marcin Ryzycki'
maintainer_email 'marcin@ryzycki.com'
license          'GPL 2'
description      'Chef cookbook for making universal PHP/Nginx/MySQL server'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.5.0'


depends 'ark', '~> 0.8.0'           # https://github.com/opscode-cookbooks/ark
depends 'yum', '~> 3.2.0'           # https://github.com/opscode-cookbooks/yum
depends 'ruby_build', '~> 0.8.0'    # https://github.com/fnichol/chef-ruby_build
depends 'chruby', '~> 0.2.1'        # https://github.com/Atalanta/chef-chruby
depends 'swap', '~> 0.3.6'          # https://github.com/sethvargo-cookbooks/swap
depends 'mysql', '~> 5.1.0'         # https://github.com/opscode-cookbooks/mysql
depends 'database', '~> 2.1.6'      # https://github.com/opscode-cookbooks/database
depends 'nginx', '~> 2.6.2'         # https://github.com/opscode-cookbooks/nginx
depends 'php', '~> 1.4.6'           # https://github.com/opscode-cookbooks/php
depends 'composer', '~> 1.0.0'      # https://github.com/escapestudios/chef-composer
depends 'logrotate', '~> 1.5.0'     # https://github.com/stevendanna/logrotate
depends 'php-fpm', '0.6.7'          # https://github.com/yevgenko/cookbook-php-fpm
