FROM php:7.4-fpm

WORKDIR /var/www

RUN apt-get update && apt-get -y install git && apt-get -y install zip

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer



RUN apt-get install -y libmcrypt-dev \
        libmagickwand-dev --no-install-recommends \
        && pecl install mcrypt-1.0.3 \
        && docker-php-ext-install pdo_mysql \
        && docker-php-ext-enable mcrypt


WORKDIR /var
RUN rm -rf www
RUN git clone https://github.com/thanhnv8421/blog www

WORKDIR /var/www

RUN chmod -R 0777 storage
RUN chmod -R 0777 bootstrap

RUN cp .env.prod .env

RUN composer install

EXPOSE 9000 9001
