#!/bin/bash
sudo mkdir -p $homedir/html
sudo chown -R $USER:$USER $homedir/html
sudo chmod -R 755 /var/www
sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/$domainname

echo "
server {
        listen 80 $domainname;
        listen [::]:80 $domainname ipv6only=on;

        root $homedir/html;
        index index.html index.htm;

        # Make site accessible from http://localhost/
        server_name localhost;

        location / {
                # First attempt to serve request as file, then
                # as directory, then fall back to displaying a 404.
                try_files $uri $uri/ =404;
                # Uncomment to enable naxsi on this location
                # include /etc/nginx/naxsi.rules
        }

" > /etc/nginx/sites-available/$domainname

ln -sf /etc/nginx/sites-available/$domainname -T /etc/nginx/sites-enabled/$domainname

rm -f /etc/nginx/sites-enabled/default
    ngx_reload