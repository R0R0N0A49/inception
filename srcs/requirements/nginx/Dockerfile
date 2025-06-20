# permet de definir la version a utiliser pour le container
FROM debian:bullseye

# permet d'installer les dependence dans le container
RUN apt update -y && apt upgrade -y
RUN apt install nginx -y
RUN apt install curl -y
RUN apt install openssl -y
RUN apt install vim -y

# cree les directory necesaire dans le container
RUN mkdir -p /etc/nginx/ssl

# Utilise open ssl pour generer un certificat (auto signer) pour une connection securiser (https)
#   'req' cree un certificat auto signer.
#   '-x509' est le type de certificat.
#   '-nodes' permet de cree le certificat sans mot de passe
#   '-out' et '-keyout' permet d'indiquer ou seront stocker le certificat et la clef ssl
#   '-subj' permet de donner les info attendu par la commands
#   'C=' = pays 'ST=' = departement/etat 'L=' localisation 'O=' organisation 'OU=' = Unité organisationnelle (?) 'CN=' nom de domaine 'UID=' identifiant utilisateur
RUN openssl req -x509 -nodes \
    -out /etc/nginx/ssl/inception.crt \
    -keyout /etc/nginx/ssl/inception.key \
    -subj "/C=FR/ST=Charente/L=Angouleme/O=42/OU=42/CN=trebours.42.fr/UID=trebours"

RUN mkdir -p /var/run/nginx
RUN mkdir -p /var/www/html

# copy la configuration de nginx donner dans le projet pour la mettre a la place de celle de base
COPY conf/nginx.conf /etc/nginx/nginx.conf

RUN chmod -R 755 /var/www/html
RUN chown -R www-data:www-data /var/www/html

CMD [ "nginx", "-g", "daemon off;" ]
