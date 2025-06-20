FROM debian:bullseye

RUN apt update -y && apt upgrade -y

RUN apt-get install mariadb-server -y
RUN rm -rf /var/lib/apt/lists/*

COPY ./tools/mariadb.sh /mariadb.sh

RUN  chmod +x /mariadb.sh

USER root

ENTRYPOINT [ "/mariadb.sh" ]