﻿#!/bin/bash
sudo mkdir -p $homedir$domainname
sudo chown -R $USER:$USER $homedir$domainname
sudo chmod -R 755 /var/www
sudo echo "10.1.1.210	$domainname" >> /etc/hosts
sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/$domainname

set MAGE_ROOT=$homedir$domainname;
set MAGE_MODE=default;
echo "
server {
        listen 80 default_server;
        listen [::]:80 default_server ipv6only=on;
#
#        root $homedir$domainname;
#        index index.php;
#		autoindex off;
#		charset off;
#
        server_name $domainname www.$domainname;
#
#       location / {
#		try_files $uri $uri/ /index.php?$args;
#		}
#		
#		# deny everything but index.php
#		location ~ ^/update/(?!pub/). {
#		deny all;
#		}
		set MAGE_ROOT=$homedir$domainname;
		set MAGE_MODE=developer;



# Magento Vars
# set $MAGE_ROOT /path/to/magento/root;
# set $MAGE_MODE default; # or production or developer
#
# Example configuration:
# upstream fastcgi_backend {
#    # use tcp connection
#    # server  127.0.0.1:9000;
#    # or socket
#    server   unix:/var/run/php5-fpm.sock;
# }
# server {
#    listen 80;
#    server_name mage.dev;
#    set $MAGE_ROOT /var/www/magento2;
#    set $MAGE_MODE developer;
#    include /vagrant/magento2/nginx.conf.sample;
# }


root $MAGE_ROOT/pub;

index index.php;
autoindex off;
charset off;

add_header 'X-Content-Type-Options' 'nosniff';
add_header 'X-XSS-Protection' '1; mode=block';

location /setup {
    root $MAGE_ROOT;
    location ~ ^/setup/index.php {
        fastcgi_pass   fastcgi_backend;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
        include        fastcgi_params;
    }

    location ~ ^/setup/(?!pub/). {
        deny all;
    }

    location ~ ^/setup/pub/ {
        add_header X-Frame-Options "SAMEORIGIN";
    }
}

location /update {
    root $MAGE_ROOT;

    location ~ ^/update/index.php {
        fastcgi_split_path_info ^(/update/index.php)(/.+)$;
        fastcgi_pass   fastcgi_backend;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
        fastcgi_param  PATH_INFO        $fastcgi_path_info;
        include        fastcgi_params;
    }

    # deny everything but index.php
    location ~ ^/update/(?!pub/). {
        deny all;
    }

    location ~ ^/update/pub/ {
        add_header X-Frame-Options "SAMEORIGIN";
    }
}

location / {
    try_files $uri $uri/ /index.php?$args;
}

location /pub {
    location ~ ^/pub/media/(downloadable|customer|import|theme_customization/.*\.xml) {
        deny all;
    }
    alias $MAGE_ROOT/pub;
    add_header X-Frame-Options "SAMEORIGIN";
}

location /static/ {
    if ($MAGE_MODE = "production") {
        expires max;
    }
    location ~* \.(ico|jpg|jpeg|png|gif|svg|js|css|swf|eot|ttf|otf|woff|woff2)$ {
        add_header Cache-Control "public";
        add_header X-Frame-Options "SAMEORIGIN";
        expires +1y;

        if (!-f $request_filename) {
            rewrite ^/static/(version\d*/)?(.*)$ /static.php?resource=$2 last;
        }
    }
    location ~* \.(zip|gz|gzip|bz2|csv|xml)$ {
        add_header Cache-Control "no-store";
        add_header X-Frame-Options "SAMEORIGIN";
        expires    off;

        if (!-f $request_filename) {
           rewrite ^/static/(version\d*/)?(.*)$ /static.php?resource=$2 last;
        }
    }
    if (!-f $request_filename) {
        rewrite ^/static/(version\d*/)?(.*)$ /static.php?resource=$2 last;
    }
    add_header X-Frame-Options "SAMEORIGIN";
}

location /media/ {
    try_files $uri $uri/ /get.php?$args;

    location ~ ^/media/theme_customization/.*\.xml {
        deny all;
    }

    location ~* \.(ico|jpg|jpeg|png|gif|svg|js|css|swf|eot|ttf|otf|woff|woff2)$ {
        add_header Cache-Control "public";
        add_header X-Frame-Options "SAMEORIGIN";
        expires +1y;
        try_files $uri $uri/ /get.php?$args;
    }
    location ~* \.(zip|gz|gzip|bz2|csv|xml)$ {
        add_header Cache-Control "no-store";
        add_header X-Frame-Options "SAMEORIGIN";
        expires    off;
        try_files $uri $uri/ /get.php?$args;
    }
    add_header X-Frame-Options "SAMEORIGIN";
}

location /media/customer/ {
    deny all;
}

location /media/downloadable/ {
    deny all;
}

location /media/import/ {
    deny all;
}

location ~ cron\.php {
    deny all;
}

location ~ (index|get|static|report|404|503)\.php$ {
    try_files $uri =404;
    fastcgi_pass   fastcgi_backend;

    fastcgi_param  PHP_FLAG  "session.auto_start=off \n suhosin.session.cryptua=off";
    fastcgi_param  PHP_VALUE "memory_limit=256M \n max_execution_time=600";
    fastcgi_read_timeout 600s;
    fastcgi_connect_timeout 600s;
    fastcgi_param  MAGE_MODE $MAGE_MODE;

    fastcgi_index  index.php;
    fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
    include        fastcgi_params;
}

}

" > /etc/nginx/sites-available/$domainname

ln -sf /etc/nginx/sites-available/$domainname -T /etc/nginx/sites-enabled/$domainname

rm -f /etc/nginx/sites-enabled/default

sudo /etc/init.d/nginx stop
wait
sudo /etc/init.d/nginx start