#!/bin/bash
export homedir=$1
export domainname=$2
#export dbname=
#export dbpass=
export MAGE_ROOT=$homedir$domainname;
export MAGE_MODE=default;
echo "our home dir:"$1
echo "domain:"$2
#export homedir
#export domainname
#/config-nginx.sh
#./install-magento.sh
#if $homedir=="" && $domainname==""; then
#echo "Homedir & domain name empty"
#exit 1;
add-apt-repository -y ppa:ondrej/php
wait
apt-get -y update
apt-get -y install nginx
apt-get -y install php7.0 php7.0-soap php7.0-fpm php7.0-mysql php7.0-zip php7.0-gd php7.0-xsl php-xml php7.0-mcrypt php7.0-curl php7.0-intl php7.0-mbstring php7.0-json 
wait
export MYSQL_ROOT_PASS=admin123
apt-get -y install debconf-utils
debconf-set-selections <<< "mysql-server mysql-server/root_password password $MYSQL_ROOT_PASS"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MYSQL_ROOT_PASS"
apt-get -y install  mysql-server-5.6
/bin/bash config-nginx.sh
wait
/bin/bash create-db.sh
wait
/bin/bash magento-install-composer.sh
wait
/bin/bash install-magento.sh
wait
sudo cp auth.json $homedir$domainname/bin/magento/
wait
sudo php $homedir$domainname/bin/magento sampledata:deploy
wait
sudo php $homedir$domainname/bin/magento setup:upgrade
wait
sudo /etc/init.d/nginx restart
#wait

echo "DONE"