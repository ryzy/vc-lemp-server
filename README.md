# LEMP server

Builds complete LEMP stack (Linux, Nginx, MySQL, PHP+PHP-FPM) for further web development.

It uses popular other cookbooks (php, mysql, nginx etc - see metadata.rb), makes them work together, adds a bit of tuning - so it results in complete, almost production ready server for PHP hosted apps (e.g. TYPO3, Drupal).

#Requirements

- Chef 11.8+

# Platform

- CentOS 6.4+

# Usage

```{ 'run_list': ['recipe[lemp-server]'] }```

# Recipes

### default
Invokes all other recipes.

### system
- Adds YUM repositories (e.g. epel, remi, remi-php55, nginx)
- Makes sure that swap is enabled
- Does yum update, yum groupinstall 'Development tools'
- Switches off some not necessary services

### web-db
- Installs/tune MySQL

### web-nginx
- Installs nginx with default vhost

### web-php
- Installs PHP 5.5, PHP-FPM and configures them to work with Nginx
- Installs composer, phpunit
- Installs phpMyAdmin

### web-tools
- Installs RVM and Ruby 2.0.0
- Installs common gems (sass, compass)

## Author

Author: ryzy (<marcin@ryzycki.com>)