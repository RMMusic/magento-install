#!/bin/bash
sudo mkdir -p $homedir$domainname
sudo chown -R $USER:$USER $homedir$domainname
sudo chmod -R 755 /var/www
sudo echo "10.1.1.210	$domainname" >> /etc/hosts
sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/$domainname
echo "
server {
        listen 80 default_server;
        listen [::]:80 default_server ipv6only=on;

        root $homedir$domainname;
        index index.php;
		autoindex off;
		charset off;

        server_name $domainname www.$domainname;

        location / {
		try_files $uri $uri/ /index.php?$args;
		}
		
		# deny everything but index.php
		location ~ ^/update/(?!pub/). {
		deny all;
		}
}

" > /etc/nginx/sites-available/$domainname

ln -sf /etc/nginx/sites-available/$domainname -T /etc/nginx/sites-enabled/$domainname

rm -f /etc/nginx/sites-enabled/default

sudo /etc/init.d/nginx stop
wait
sudo /etc/init.d/nginx start