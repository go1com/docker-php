FROM alpine:edge
# Add edge cdn
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk add --no-cache bash \
        nginx \
        curl \
        php7 \
        php7-fpm \
        php7-bcmath \
        php7-bz2 \
        php7-calendar \
        php7-ctype \
        php7-curl \
        php7-dom \
        php7-exif \
        php7-ftp \
        php7-gettext \
        php7-gd \
        php7-iconv \
        php7-intl \
        php7-imap \
        php7-json \
        php7-mysqlnd \
        php7-mysqli \
        php7-mcrypt \
        php7-memcached \
        php7-mbstring \
        php7-opcache \
        php7-openssl \
        php7-pdo \
        php7-pdo_mysql \
        php7-pdo_pgsql \
        php7-pdo_sqlite \
        php7-phar \
        php7-posix \
        php7-pgsql \
        php7-session \
        php7-soap \
        php7-sockets \
        php7-sqlite3 \
        php7-tokenizer \
        php7-wddx \
        php7-xml \
        php7-xmlreader \
        php7-xsl \
        php7-zip \
        php7-zlib \
        ca-certificates && \
    rm -rf /var/cache/apk/* && \
    mkdir -p /etc/nginx && \
    mkdir -p /run/nginx && \
    rm -Rf /etc/nginx/nginx.conf && \
    mkdir -p /etc/nginx/sites-available/ && \
    mkdir -p /etc/nginx/sites-enabled/ && \
    mkdir -p /app/public/ && \
    ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf

COPY rootfs /
EXPOSE 80
RUN chmod a+x /start.sh
CMD ["/start.sh"]
