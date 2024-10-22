# Symfony uchun Apache serveri bazasini qo'llash
FROM php:8.2-apache

# Apache2 konfiguratsiyasi uchun Symfony webroot papkani tanlash
ENV APACHE_DOCUMENT_ROOT /var/www/html/public

# Apache2 serveri konfiguratsiyasini yangilash
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Symfony proyektini serverga ko'chirish
COPY . /var/www/html

# Composer va diger lozimli kirishlar
RUN apt-get update && apt-get install -y \
    git \
    zip \
    unzip \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# PHP 8.2 uchun modullar
RUN docker-php-ext-install pdo_mysql

# Symfony 7.1 uchun Composer paketlarini o'rnatish
RUN composer require symfony/symfony:7.1

# Portni ochish
EXPOSE 80