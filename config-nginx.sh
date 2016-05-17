#!/bin/bash
sudo mkdir -p $homedir/html
sudo chown -R $USER:$USER $homedir/html
sudo chmod -R 755 /var/www
sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/$domainname

echo "
server {
        listen 80 default_server;
        listen [::]:80 default_server ipv6only=on;

        root $homedir/html;
        index index.html index.htm;

        server_name $domainname www.$domainname;

        location / {
           try_files $uri $uri/ =404;
        }

" > /etc/nginx/sites-available/$domainname

ln -sf /etc/nginx/sites-available/$domainname -T /etc/nginx/sites-enabled/$domainname

rm -f /etc/nginx/sites-enabled/default
