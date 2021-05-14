FROM php:7.3-apache

LABEL maintainer="James Chou <totem.james@gmail.com>"

RUN apt-get update
RUN apt-get upgrade -y


RUN apt-get install --fix-missing -y libpq-dev
RUN apt-get install --no-install-recommends -y libpq-dev
RUN apt-get install -y libxml2-dev libbz2-dev zlib1g-dev
RUN apt-get -y install libsqlite3-dev libsqlite3-0 mariadb-client curl exif ftp
RUN docker-php-ext-install intl
RUN docker-php-ext-install mysqli pdo pdo_mysql
RUN docker-php-ext-enable mysqli
RUN docker-php-ext-enable pdo
RUN docker-php-ext-enable pdo_mysql
RUN apt-get -y install --fix-missing zip unzip
RUN apt-get -y install --fix-missing git
RUN apt-get -y install vim

# xdebug
RUN pecl install xdebug
RUN echo "zend_extension=$(find / -name xdebug.so)" > /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo 'xdebug.client_port=9000' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo 'xdebug.mode=debug' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo 'xdebug.client_host=host.docker.internal' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN composer self-update --2

ADD docker-conf/apache.conf /etc/apache2/sites-available/000-default.conf

RUN a2enmod rewrite

ADD startScript.sh /startScript.sh
RUN chmod +x /startScript.sh


# 安裝 CodeIgniter 主檔 如果已經有檔案就不用
RUN cd /var/www/html
RUN composer create-project codeigniter4/appstarter ./tempfile
RUN chmod -R 0777 /var/www/html/tempfile/writable

RUN mv tempfile/* ./ 
RUN mv tempfile/.gitignore ./.gitignore

ADD docker-conf/env /var/www/html/.env


RUN apt-get clean \
    && rm -r /var/lib/apt/lists/*
    
EXPOSE 80
VOLUME ["/var/www/html"]

CMD ["bash", "/startScript.sh"]
