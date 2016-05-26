#!/bin/bash
sudo mkdir -p $homedir$domainname
sudo chown -R www-data:www-data $homedir$domainname
sudo chmod -R 755 $homedir$domainname
sudo echo "10.1.1.210	$domainname" >> /etc/hosts
sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/$domainname

#set MAGE_ROOT=$homedir$domainname;
#set MAGE_MODE=default;
#echo $MAGE_ROOT
#echo $MAGE_MODE
echo "
upstream fastcgi_backend {
     server 127.0.0.1:9000;
						 }
server {
    listen 80;
    server_name $domainname;
    set '$MAGE_ROOT' $homedir$domainname;
    set '$MAGE_MODE' default;
    include /var/www/m.com/nginx.conf.sample;
       }

}

" > /etc/nginx/sites-available/$domainname

ln -sf /etc/nginx/sites-available/$domainname -T /etc/nginx/sites-enabled/$domainname

rm -f /etc/nginx/sites-enabled/default

sudo /etc/init.d/nginx restart
