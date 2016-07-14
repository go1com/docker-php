FROM php:7-fpm
MAINTAINER sang@go1.com.au

# Install modules
RUN apt-get update \
    && apt-get install -y -qq libpng12-dev libjpeg-dev libpq-dev git libmcrypt-dev libicu-dev libmemcached-dev libz-dev libxml2-dev libssl-dev libcurl4-openssl-dev zlib1g-dev \
    && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
    && docker-php-ext-install -j$(nproc) bcmath gd gettext intl mbstring mcrypt opcache pdo pdo_mysql xml zip \
    && git clone https://github.com/php-memcached-dev/php-memcached /usr/src/php/ext/memcached \
    && cd /usr/src/php/ext/memcached && git checkout -b php7 origin/php7 \
    && phpize && ./configure && make && make install && docker-php-ext-enable memcached \
    && echo "upload_max_filesize = 200M\npost_max_size = 200M" > /usr/local/etc/php/conf.d/uploads.ini \
    && echo "log_errors=On\nerror_reporting=E_ERROR | E_WARNING | E_PARSE | E_NOTICE" > /usr/local/etc/php/conf.d/errors.ini \
    && echo 'date.timezone = UTC' >> /usr/local/etc/php/php.ini \
    && apt-get clean && rm -rf /var/lib/apt/lists/*