FROM ubuntu:21.04

# Variables de entorno
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Lima
ENV APACHE_DOCUMENT_ROOT=/var/www/html/vtiger740

# Instalación de dependencias
RUN apt -y update
RUN apt install -y apache2 wget tar cron && apt clean
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
#  PHP v7.4.16 (cli)
RUN apt -y install php php-cli php-common php-gd php-mysql php-xml php-imap php-mbstring php-pdo php-curl php-fileinfo php-json php-dom php-ldap php-zip php-bcmath php-soap

# Crea el ambiente de trabajo
RUN mkdir -p /var/www/html/vtiger740
WORKDIR /var/www/html/vtiger740
COPY ./ /var/www/html/vtiger740
# Permisos para el vtigercron
RUN chmod 755 /var/www/html/vtiger740/cron/vtigercron.sh
RUN chmod 755 /var/www/html/vtiger740/vtigercron.php

# Configura php.ini
COPY ./docker-config/php74/php.ini /etc/php/7.4/apache2/php.ini

# Configurar CRON de Vtiger
# Add crontab file in the cron directory
ADD vtiger-cron /etc/cron.d/vtiger-cron
# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/vtiger-cron
# Apply cron job
RUN crontab /etc/cron.d/vtiger-cron
# Create the log file to be able to run tail
RUN touch /var/log/cron.log

# Inicia el servicio de apache y cron
CMD cron && apachectl -D FOREGROUND