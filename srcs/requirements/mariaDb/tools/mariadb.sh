#!/bin/bash

mysql_install_db

/etc/init.d/mysql start

if [ -d "/var/lib/mysql/$MARIADB_DATABASE" ]
then
  echo "Database is already creat"
else

  mysql_secure_installation << _EOF_

Y
$MARIADB_ROOT_PASSWORD
$MARIADB_ROOT_PASSWORD
Y
n
Y
Y
_EOF_

  echo "GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '$MARIADB_ROOT_PASSWORD'; FLUSH PRIVILEGES;" | mysql -uroot

  echo "CREATE DATABASE IF NOT EXISTS $MARIADB_DATABASE; GRANT ALL ON $MARIADB_DATABASE.* TO '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_PASSWORD'; FLUSH PRIVILEGES;" | mysql -u root

mysql -uroot -p$MARIADB_ROOT_PASSWORD $MARIADB_DATABASE < /usr/local/bin/wordpress.sql

fi

/etc/init.d/mysql stop

exec "$@"