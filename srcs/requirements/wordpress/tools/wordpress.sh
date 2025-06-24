#!/bin/bash

# Check if MariaDB is accessible using mysqladmin
echo if mysqladmin ping -h "${WORDPRESS_DB_HOST}" -u "${MARIADB_USER}" "--password=${MARIADB_PASS}" --silent

mkdir -p /run/php

# to wait until MariaDB is available before proceeding
echo "Waiting for MariaDB to be available..."
for i in {1..60}; do
    if mysqladmin ping -h "${WORDPRESS_DB_HOST}" -u "${MARIADB_USER}" "--password=${MARIADB_PASS}" --silent; then
        echo "MariaDB is up."
        break
    else
        echo "MariaDB not available, retrying in 10 seconds..."
        sleep 10
    fi
done

cd ${WORDPRESS_PATH}

if [ -f wp-config.php ]; then
	echo "wordpress already installed"
else


# Download wordPress files
if [ ! -f /usr/local/bin/wp ]; then
    echo "Downloading WP-CLI..."
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

echo "Downloading WordPress core files..."
wp core download --allow-root

echo "Generating wp-config.php..."
wp config create \
    --dbname="${MARIADB_DATABASE}" \
    --dbuser="${MARIADB_USER}" \
    --dbpass="${WORDPRESS_DB_PASS}" \
    --dbhost="${WORDPRESS_DB_HOST}" \
    --allow-root

echo "Installing WordPress..."
mysql -h "${WORDPRESS_DB_HOST}" -u "${MARIADB_USER}" "--password=${MARIADB_PASS}" -e "DROP DATABASE IF EXISTS ${MARIADB_DATABASE}; CREATE DATABASE ${MARIADB_DATABASE};"

wp core install \
    --url="${WORDPRESS_URL}" \
    --title="${TITLE}" \
    --admin_user="${WORDPRESS_ADMIN_USER}" \
    --admin_password="${WORDPRESS_ADMIN_PASS}" \
    --admin_email="${WORDPRESS_ADMIN_EMAIL}" \
    --allow-root

echo "Creating additional WordPress user..."
wp user create ${WORDPRESS_USER} ${WORDPRESS_USER_EMAIL} --role=author --user_pass=${WORDPRESS_USER_PASS} --allow-root

chmod -R 775 wp-content

fi
# Start PHP-FPM
exec php-fpm7.4 -F