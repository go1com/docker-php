FROM php:7-fpm-alpine
MAINTAINER sang@go1.com.au

# Install modules
RUN apk add --no-cache --virtual .persistent-deps \
  libintl \
  libmcrypt \
  icu-libs \
  freetype \
  libpng \
  nginx \
  libjpeg-turbo \
  && rm -rf /var/cache/apk/*

RUN apk add --no-cache --virtual .build-deps \
    freetype-dev \
    libpng-dev \
    libjpeg-turbo-dev \
    libmcrypt-dev \
    libxml2-dev \
    gettext-dev \
    icu-dev \
  && docker-php-ext-configure gd \
    --with-gd \
    --with-freetype-dir=/usr/include/ \
    --with-png-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/ \
  && NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
  && docker-php-ext-install -j${NPROC} bcmath gd gettext intl mcrypt opcache pdo pdo_mysql xml zip \
  && apk del .build-deps
