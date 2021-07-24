Vtiger CRM
==========
[Es]

- Fecha de descarga del código fuente: 21/07/2021 (DD/MM/YYYY)
- Fuente: https://www.vtiger.com/es/open-source-crm/download-open-source/#download
- Versión: 7.4.0
- Autor: hcumbicusr@gmail.com

Despliegue de Docker:
=====================
[1] Variables de entorno
====================================
- Renombre el archivo example.env a .env y configure las variables de entorno del servidor y vtiger
[Contenido del archivo (.env)]
- MYSQL_ROOT_PASSWORD= [Contraseña del usuario root]
- MYSQL_DATABASE=[Nombre de la BD de vtiger]
- MYSQL_USER=[Nombre del usuario vtiger]
- MYSQL_PASSWORD=[Contraseña del usuario vtiger]
- DB_HOST=db
- DB_PORT=3306
- DB_CHARSET=utf8
- DB_COLLATION=utf8_general_ci
- APACHE_PORT=80
- EXTERNAL_APACHE_PORT=[8080: Puerto de docker para consultas externas]
- EXTERNAL_DB_PORT=[3309: Puerto de mysql para consultas externas]
- SITE_URL=[http://localhost:8080/ # URL para usar vtiger]
- UPLOAD_MAXSIZE=50000000
- LIST_MAX_ENTRIES_PER_PAGE=50

[2] Configuración de PHP
====================================
- El archivo de configuración php.ini se encuentra en /docker-config/php74/config.ini

[3] Desplegar el contenedor
====================================
- Luego de realizada la configuración inicial se procede a desplegar docker
> docker-compose build
> docker-compose up -d

[4] Solo cuando se despliega por primera vez el cotenedor
======================================================================
- IMPORTANTE: Solo ejecutar la primera vez que se despliega el contenedor
- Esto abrirá la consola del servidor MySql
> docker exec -it php-docker-vtiger-740_db_1 bash
- Ahora debemos restaurar la BD inicial de vtiger, en la consola de mysql
> mysql -uroot -p[MYSQL_ROOT_PASSWORD] [MYSQL_DATABASE] < /backup/db_vtiger_740_20210724.sql
- Cerramos la consola
> exit

- IMPORTANTE: Solo ejecutar la primera vez que se despliega el contenedor
- El siguiente comando genera el $application_unique_key del archivo config.inc.php y el secret-key csrf de vtiger, reemplazará el valor {APPLICATION_UNIQUE_KEY} en el archivo config.inc.php y creará el archivo config.csrf-secret.php
> doker-compose run web php -f /var/www/html/vtiger740/generate_key.php

[5] Acceso a Vtiger desde el navegador
================================================================
- URL: [SITE_URL]
- User: admin
- Password: vTiger@2021
* Por favor cambie la contraseña

[6] Eliminar phpinfo.php
===================================
- Se recomienda eliminar el archivo phpinfo.php