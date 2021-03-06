﻿#!/bin/bash
sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/$domainname
echo "set \$MAGE_ROOT $homedir$domainname;
set \$MAGE_MODE default;" | cat - $homedir$domainname/nginx.conf.sample > temp && mv temp $homedir$domainname/nginx.conf.sample
echo "
upstream fastcgi_backend {
     server 127.0.0.1:9000;
	 server unix:/var/run/php/php7.0-fpm.sock;
						 }
server {
    listen 80;
    server_name $domainname;
    include $homedir$domainname/nginx.conf.sample;
       }
" > /etc/nginx/sites-available/$domainname

ln -sf /etc/nginx/sites-available/$domainname -T /etc/nginx/sites-enabled/$domainname

rm -f /etc/nginx/sites-enabled/default

sudo /etc/init.d/nginx reload
