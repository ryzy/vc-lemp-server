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
