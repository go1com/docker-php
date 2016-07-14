FROM php:5.6-fpm
MAINTAINER sang@go1.com.au

# Install modules
RUN apt-get update \
    && apt-get install -y libmcrypt-dev libicu-dev libmemcached-dev libz-dev libmcrypt-dev libicu-dev libxml2-dev libssl-dev libcurl4-openssl-dev zlib1g-dev \
    && docker-php-ext-install -j$(nproc) gettext intl mbstring mcrypt opcache pdo_mysql xml \
    && pecl install memcache \
    && docker-php-ext-enable memcache \
    && echo "upload_max_filesize = 200M\npost_max_size = 200M" > /usr/local/etc/php/conf.d/uploads.ini \
    && echo "log_errors=On\nerror_reporting=E_ERROR | E_WARNING | E_PARSE | E_NOTICE" > /usr/local/etc/php/conf.d/errors.ini \
    && echo 'date.timezone = UTC' >> /usr/local/etc/php/php.ini \
    && apt-get clean && rm -rf /var/lib/apt/lists/*