#!/bin/bash
    mysql -uroot -p$MYSQL_ROOT_PASS -e "CREATE DATABASE ${dbname} /*\!40100 DEFAULT CHARACTER SET utf8 */;"
    mysql -uroot -p$MYSQL_ROOT_PASS -e "CREATE USER ${dbname}@localhost IDENTIFIED BY '${dbpass}';"
    mysql -uroot -p$MYSQL_ROOT_PASS -e "GRANT ALL PRIVILEGES ON ${dbname}.* TO '${dbname}'@'localhost';"
    mysql -uroot -p$MYSQL_ROOT_PASS -e "FLUSH PRIVILEGES;"
