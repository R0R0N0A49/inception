#!/bin/bash

# Démarrer temporairement MariaDB en arrière-plan
service mariadb start

# Attendre quelques secondes pour que MariaDB soit prêt
sleep 5

# Créer la base de données si elle n'existe pas
mysql -u root -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"

# Créer l'utilisateur SQL s'il n'existe pas
mysql -u root -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"

# Donner tous les droits à cet utilisateur sur la base de données
mysql -u root -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%';"

# Modifier le mot de passe du root
mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"

# Appliquer les changements
mysql -u root -p${SQL_ROOT_PASSWORD} -e "FLUSH PRIVILEGES;"

# Arrêter MariaDB proprement
mysqladmin -u root -p${SQL_ROOT_PASSWORD} shutdown

# Redémarrer le service en mode sécurisé
exec mysqld_safe
