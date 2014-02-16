## 0.2.0 (2014-02-16)

Features:
- Test Kitchen tests for all recipes (@see http://kitchen.ci/)
- man pages installed ;-)
- vagrant user dependency removed
- php unit installed

Breaking changes:
- NFS recipe removed: [Vagrant 1.5 is comming with rsync support](https://github.com/mitchellh/vagrant/blob/master/website/docs/source/v2/synced-folders/rsync.html.md)
- RVM removed (due to conflicting with chef)

Bugfixes:
- Fixes for newest Chef 11.10.0
- Fix for swap on Rackspace
- Fix for nginx logs permissions


## 0.1.3 (2014-02-10)

- Sass/Compass gems updated to newest versions (3.3.0.rc.3, 1.0.0.alpha.18 respectively)

## 0.1.2 (2014-02-09)

Features:
- npm installed
- OpCacheGUI installed and availabe via default vhost

Bugfixes:
- Vagrantfile: chef version constrained to 10.8.0 (due to buggy 10.10.0)
- PHP: opcache.fast_shutdown set to Off to prevent PHP segfault with message 'zend_mm_heap corrupted'
- logrotate permission fix for nginx

## 0.1.1 (2014-02-03)

- Rackspace provided config added in Vagrantfile

## 0.1.0 (2014-01-31)

- Initial version, extracted from [ryzy/vc-typo3-neos](https://github.com/ryzy/vc-typo3-neos) project
