#!/bin/bash

. $(dirname $0)/webserver_config.sh

mysql -u root -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE IF NOT EXISTS $1;"
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "CREATE USER IF NOT EXISTS '$2'@'%' IDENTIFIED BY '$3';"
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "GRANT ALL PRIVILEGES ON $1.* TO '$2'@'%' WITH GRANT OPTION;"
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "ALTER USER '$2'@'%' IDENTIFIED WITH mysql_native_password BY '$3';"
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "FLUSH PRIVILEGES;"
