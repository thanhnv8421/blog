FROM php:7.4-fpm

COPY composer.json /var/www/

COPY database /var/www/database

WORKDIR /var/www

RUN apt-get update && apt-get -y install git && apt-get -y install zip

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY . /var/www

RUN chown -R www-data:www-data \
        /var/www/storage \
        /var/www/bootstrap/cache

RUN chmod -R 775 /var/www/storage \
        /var/www/bootstrap/cache

RUN apt-get install -y libmcrypt-dev \
        libmagickwand-dev --no-install-recommends \
        && pecl install mcrypt-1.0.3 \
        && docker-php-ext-install pdo_mysql \
        && docker-php-ext-enable mcrypt

USER root
RUN apt-get update && \
    apt-get install -y supervisor

ADD docker/supervisor/supervisord.conf /etc/supervisor/supervisord.conf
RUN ln -s /var/www/supervisor/config.conf /etc/supervisor/conf.d/config.conf

#RUN apt-get install -y supervisor

#COPY docker/supervisor/supervisord.conf /etc/supervisord.conf

#ENTRYPOINT ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]

RUN composer install

RUN php artisan key:generate

# RUN php artisan optimize

EXPOSE 9000 9001

