#!/bin/bash
export homedir=$1
export domainname=$2
export dbname=$3
export dbpass=$4
export MAGE_ROOT=$homedir$domainname;
export MAGE_MODE=default;
echo "our home dir:"$1
echo "domain:"$2
echo "dbname:"$3
echo "dbpass:"$4
#export homedir
#export domainname
#/config-nginx.sh
#./install-magento.sh
#if $homedir=="" && $domainname==""; then
#echo "Homedir & domain name empty"
#exit 1;
add-apt-repository -y ppa:ondrej/php
wait
apt-get -y update && apt-get -y upgrade
apt-get -y install nginx
wait
apt-get -y install php7.0 php7.0-soap php7.0-fpm php7.0-mysql php7.0-zip php7.0-gd php7.0-xsl php-xml php7.0-mcrypt php7.0-curl php7.0-intl php7.0-mbstring php7.0-json 
wait
export MYSQL_ROOT_PASS=admin123
apt-get -y install debconf-utils
debconf-set-selections <<< "mysql-server mysql-server/root_password password $MYSQL_ROOT_PASS"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MYSQL_ROOT_PASS"
apt-get -y install  mysql-server-5.6
wait
/bin/bash create-db.sh
wait
sudo mkdir -p $homedir$domainname
sudo chown -R www-data:www-data $homedir$domainname
wait
sudo chmod -R 755 $homedir$domainname
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
sudo /etc/init.d/nginx restart
#wait
echo "DONE"