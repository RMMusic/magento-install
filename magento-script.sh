#!/bin/bash
#importing variables from comand-line arguments and exporting them to make posible using in all scripts
export homedir=$1
export domainname=$2
export dbrootpass=$3
export dbname=$4
export dbpass=$5
export adminlog=$6
export adminpass=$7

echo "our home dir:"$1
echo "domain:"$2
echo "dbrootpass:"$3
echo "dbname:"$4
echo "dbpass:"$5
echo "adminlog:"$6
echo "adminpass:"$7
#adding repository containing php7.0 and modules
add-apt-repository -y ppa:ondrej/php
wait
apt-get -y update && apt-get -y upgrade
apt-get -y install nginx
wait
#installing php-modules needing to magento 2 works properly
apt-get -y install php7.0 php7.0-soap php7.0-fpm php7.0-mysql php7.0-zip php7.0-gd php7.0-xsl php-xml php7.0-mcrypt php7.0-curl php7.0-intl php7.0-mbstring php7.0-json 
wait
#export MYSQL_ROOT_PASS=admin123
apt-get -y install debconf-utils
debconf-set-selections <<< "mysql-server mysql-server/root_password password $dbrootpass"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $dbrootpass"
apt-get -y install  mysql-server-5.6
wait
/bin/bash create-db.sh
#create homedir
wait
sudo mkdir -p $homedir$domainname
wait
/bin/bash magento-install-composer.sh
wait
/bin/bash install-magento.sh
wait
/bin/bash config-nginx.sh
wait
sudo cp auth.json $homedir$domainname/var/composer_home/
wait
sudo php $homedir$domainname/bin/magento sampledata:deploy
wait
sudo php $homedir$domainname/bin/magento setup:upgrade
wait
#grands ownage and write permissions for nginx user
sudo chown -R www-data:www-data $homedir*
wait
sudo chmod -R 755 $homedir*
wait
sudo /etc/init.d/nginx reload
wait
echo "DONE"