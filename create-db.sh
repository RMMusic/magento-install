#!/bin/bash
MAINDB=magento2
PASSWDDB=magento12345
 mysql -uroot -p $MYSQL_ROOT_PASS -e "CREATE DATABASE ${MAINDB} /*\!40100 DEFAULT CHARACTER SET utf8 */;"
    mysql -uroot -p $MYSQL_ROOT_PASS -e "CREATE USER ${MAINDB}@localhost IDENTIFIED BY '${PASSWDDB}';"
    mysql -uroot -p $MYSQL_ROOT_PASS -e "GRANT ALL PRIVILEGES ON ${MAINDB}.* TO '${MAINDB}'@'localhost';"
    mysql -uroot -p $MYSQL_ROOT_PASS -e "FLUSH PRIVILEGES;"