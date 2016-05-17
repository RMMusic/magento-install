#!/bin/bash
export homedir=$1
export domainname=$2
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
apt-get -y install php7.0 php7.0-fpm php7.0-mysql php7.0-zip php7.0-gd
wait
#take mysql root pass

echo "Please enter mysql root pass: "
read MYSQL_ROOT_PASS
apt-get -y install debconf-utils
debconf-set-selections <<< "mysql-server mysql-server/root_password password $MYSQL_ROOT_PASS"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MYSQL_ROOT_PASS"

apt-get -y install  mysql-server-5.6

/bin/bash config-nginx.sh
/bin/bash magento-install-composer.sh
wait
/bin/bash install-magento.sh