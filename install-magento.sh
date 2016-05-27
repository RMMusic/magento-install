#!/bin/bash
cd $homedir$domainname
sudo php -f bin/magento setup:install --base-url=http://$domainname \
--db-host=localhost --db-name=$dbname --db-user=$dbname --db-password=$dbpass \
--admin-firstname=Magento --admin-lastname=User --admin-email=user@example.com \
--admin-user=$adminlog --admin-password=$adminpass --language=en_US --currency=USD --timezone=America/Chicago --use-rewrites=1
