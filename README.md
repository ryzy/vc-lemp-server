# LEMP server

Builds complete LEMP stack (Linux, Nginx, MySQL, PHP+PHP-FPM) for further web development.

It uses popular, mainly Opscode cookbooks (php, mysql, nginx etc - see metadata.rb), makes them work together, adds a bit of spicing and tuning - so it results in a complete, almost production ready server for PHP hosted apps (e.g. Symfony2, TYPO3, Drupal). I say 'almost production ready' because you will secure the setup according to your needs (probably in a separate recipe) + you add recipe dedicated for your app.

## UPDATE

**Nowadays I advocate for running your applications inside Docker containers.** Please have a look at my Docker repositories here: https://github.com/million12?query=docker . This repository is **not** maintained any longer.

---

#Requirements

- Chef 11.8+

# Platform

- CentOS 6.4+

# Usage

```{ 'run_list': ['recipe[lemp-server]'] }```

After the machine is successfully provisioned, you should see welcome page under http://VM_IP/ with links to phpMyAdmin, OpCache GUI and printout from phpinfo().

# Recipes

### default
Invokes all other recipes.

### system
- Adds YUM repositories (e.g. epel, remi, remi-php55, nginx)
- Makes sure that swap is enabled
- Does yum update, yum groupinstall 'Development tools'
- Switches off some not necessary services

### ruby

- Install Ruby 2.0, [chruby](https://github.com/postmodern/chruby)
- Install Bundler and updates RubyGems

### web-db
- Installs/tune MySQL 5.5

### web-nginx
- Installs nginx with default vhost

### web-php
- Installs PHP 5.5, PHP-FPM and configures them to work with Nginx
- Installs composer, phpunit
- Installs phpMyAdmin
- Installs [OPCache GUI](https://github.com/PeeHaa/OpCacheGUI) to monitor default PHP opcache optimizer

### web-tools
- empty for now

## Testing

Tests are written in [serverspec](serverspec.org) and runnin using [KitchenCI](http://kitchen.ci/). 

Currently configured providers: Vagrant (using default providers), Rackspace, DigitalOcean. You 

Usage:

```kitchen list```

```kitchen test```



## Author

Author: ryzy marcin@m12.io

---

**Sponsored by** [Typostrap.io - the new prototyping tool](http://typostrap.io/) for building highly-interactive prototypes of your website or web app. Built on top of TYPO3 Neos CMS and Zurb Foundation framework.
