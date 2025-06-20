FROM debian:bullseye

RUN apt update -y && apt upgrade -y
RUN apt-get install -y php7.4-fpm php7.4-mysql curl mariadb-client

COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY tools/wordpress.sh /usr/local/bin/wordpress.sh

RUN chmod +x /usr/local/bin/wordpress.sh

CMD ["/usr/local/bin/wordpress.sh"]