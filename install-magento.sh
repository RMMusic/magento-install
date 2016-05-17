#!/bin/bash
cd /var/www/html/bin
sudo php magento setup:install --base-


user=magento2 --db-password=magento12345 --admin-firstname=Magento --admin-lastname=User 

--admin-email=user@example.com --admin-user=admin --admin-password=admin123 --

language=en_US --currency=USD --timezone=America/Chicago --use-rewrites=1


