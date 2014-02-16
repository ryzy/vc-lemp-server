#
# Cookbook Name:: lemp-server
# Recipe:: default
#
# Copyright (C) 2014 ryzy
#

include_recipe 'lemp-server::system'           # system basic setup (repos, tweaks)
include_recipe 'lemp-server::web-tools'        # Web tools: ruby, sass, compass etc
include_recipe 'lemp-server::web-db'           # Web: MySQL
include_recipe 'lemp-server::web-nginx'        # Web: Nginx server
include_recipe 'lemp-server::web-php'          # Web: PHP, PHP-FPM, composer, phpMyAdmin
include_recipe 'lemp-server::user'             # user preferences etc
