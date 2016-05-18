#!/bin/bash
cd $homedir/html/bin
sudo php magento setup:install --base-url=http://$domainname/magento2/ --db-host=localhost --db-name=magento2 --db-user=magento2 --db-password=magento12345 --admin-firstname=Magento --admin-lastname=User --admin-email=user@example.com --admin-user=admin --admin-password=admin123 --
language=en_US --currency=USD --timezone=America/Chicago --use-rewrites=1


