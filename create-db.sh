#!/bin/bash
    mysql -uroot -p$dbrootpass -e "CREATE DATABASE ${dbname} /*\!40100 DEFAULT CHARACTER SET utf8 */;"
    mysql -uroot -p$dbrootpass -e "CREATE USER ${dbname}@localhost IDENTIFIED BY '${dbpass}';"
    mysql -uroot -p$dbrootpass -e "GRANT ALL PRIVILEGES ON ${dbname}.* TO '${dbname}'@'localhost';"
    mysql -uroot -p$dbrootpass -e "FLUSH PRIVILEGES;"
