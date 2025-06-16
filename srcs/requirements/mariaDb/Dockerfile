FROM alpine:3.17

# Installer MariaDB avec apk (pas apt)
RUN apk update && apk upgrade && \
    apk add mariadb mariadb-client mariadb-common mariadb-openrc

# Copier le fichier de config MariaDB dans le bon répertoire
COPY ./conf/50-server.cnf /etc/my.cnf.d/50-server.cnf

# Créer les répertoires nécessaires (si besoin)
RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

# Exposer le port standard de MariaDB
EXPOSE 3306

# Démarrer MariaDB (simple exemple de CMD)
CMD ["mysqld"]
